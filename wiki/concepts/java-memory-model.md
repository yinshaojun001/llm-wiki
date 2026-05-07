---
title: Java 内存模型（JVM Memory Model）
tags: [concept, java, jvm, memory, heap, stack, gc]
date: 2026-04-13
sources: []
---

# Java 内存模型（JVM Memory Model）

Java 没有指针（pointer），但有引用（reference）。理解这两者的区别，以及对象在 JVM 中的存储方式，是理解拷贝语义的前提。

---

## 1. Stack vs Heap

### Stack（线程栈）

- 每个线程拥有独立的栈，不共享。
- 存储：局部变量、方法调用帧（frame）、基本类型的值（int/long/double/boolean 等）。
- 对象引用变量本身也在栈上，但它指向堆上的对象。
- 栈是 LIFO 结构，方法返回时自动释放，不需要 GC。
- 默认大小约 512KB–1MB（可通过 `-Xss` 调整）。

### Heap（堆）

- JVM 进程全局共享的一块内存区域。
- 所有 `new` 出来的对象实例都在堆上。
- 堆受 GC 管理，对象无强引用后才会被回收。
- 通过 `-Xms`（初始大小）和 `-Xmx`（最大大小）配置。

### 文本示意图

```
Thread 1 Stack          Thread 2 Stack            HEAP
┌─────────────────┐    ┌──────────────────┐   ┌─────────────────────────────┐
│ main() frame    │    │ process() frame  │   │                             │
│  int x = 5     │    │  int y = 10      │   │  Person@A1B2                │
│  Person p ──────┼────┼──────────────────┼──►│   name: "Alice"            │
│                 │    │  Person p2 ──────┼──►│   age: 30                  │
│                 │    │                  │   │                             │
└─────────────────┘    └──────────────────┘   │  int[] arr@C3D4            │
                                              │   [1, 2, 3, 4, 5]          │
                                              └─────────────────────────────┘
```

关键点：`p` 和 `p2` 是两个不同的引用变量（在各自的栈上），但它们指向的是同一个 `Person` 对象（堆上的同一块内存）。

---

## 2. Java 引用 vs C/C++ 指针

| 特性 | C/C++ 指针 | Java 引用 |
|------|-----------|---------|
| 取地址 | `&variable` 可获取原始内存地址 | 无法获取实际地址（`System.identityHashCode()` 返回的不一定是地址） |
| 指针运算 | `ptr++`、`*(ptr+3)` | 不允许 |
| 空值 | `NULL` | `null` |
| 解引用 | 显式 `*ptr` | 自动，`.`操作符就是解引用 |
| 悬空指针 | 存在风险（free 后访问） | 不存在（GC 负责回收） |
| 多级指针 | `int **pp` | 不支持，引用只有一层 |
| 引用相等 | `ptr1 == ptr2` 比较地址 | `obj1 == obj2` 比较引用（即地址），`.equals()` 比较逻辑相等 |

Java 的引用在 HotSpot JVM 内部是一个 32/64 位的值，指向堆中对象的起始偏移。启用 CompressedOops（默认开启，堆 < 32GB 时）时，引用是 32 位编码，节省内存。

```java
Person p = new Person("Alice", 30);
// p 是一个引用，占 4 字节（CompressedOops）或 8 字节
// 实际 Person 对象在堆上，包含：
//   - 对象头（mark word 8字节 + class pointer 4字节）
//   - 实例字段（name 引用 4字节 + age int 4字节）
// 合计约 20 字节（按 8 字节对齐则为 24 字节）
```

---

## 3. JVM 堆分代结构（HotSpot G1 之前的经典模型）

```
┌────────────────────────────────────────────────────────────┐
│                         HEAP                               │
│  ┌─────────────────────────────────┐  ┌──────────────────┐ │
│  │         Young Generation        │  │  Old Generation  │ │
│  │  ┌──────────┐  ┌───┐  ┌───┐   │  │  (Tenured Space) │ │
│  │  │  Eden    │  │S0 │  │S1 │   │  │                  │ │
│  │  │  Space   │  │   │  │   │   │  │  长期存活对象      │ │
│  │  │  (大多数  │  │Survivor│  │  │  │  大对象直接进入   │ │
│  │  │  new在此)│  │   │  │   │   │  │                  │ │
│  │  └──────────┘  └───┘  └───┘   │  └──────────────────┘ │
│  └─────────────────────────────────┘                       │
│                                                            │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Metaspace（JDK 8+，替代 PermGen）                  │    │
│  │  类的元数据、静态变量、字节码、常量池               │    │
│  └────────────────────────────────────────────────────┘    │
└────────────────────────────────────────────────────────────┘
```

### 对象生命周期

1. **分配**：新对象通常在 Eden 区分配（使用 TLAB，Thread Local Allocation Buffer，无锁分配）。
2. **Minor GC**：Eden 满后触发，存活对象移入 Survivor（S0 或 S1），年龄（age）+1。
3. **晋升（Promotion）**：年龄超过阈值（默认 15）的对象移入 Old Generation。
4. **Major/Full GC**：Old Gen 满后触发，代价高，Stop-The-World 时间长。

### G1 GC 模型（JDK 9+ 默认）

G1 不再使用物理连续的 Young/Old 区域，而是将堆切分为大小相等的 **Region**（1–32 MB），按需标记为 Eden/Survivor/Old/Humongous（大对象）。概念上的分代仍然存在，但物理布局更灵活，可预测停顿时间（`-XX:MaxGCPauseMillis`）。

---

## 4. 对象头结构（Object Header）

每个 Java 对象在堆上由两部分组成：

```
┌──────────────────────────────────────────────┐
│  Object Header                               │
│  ├── Mark Word (8 bytes)                     │
│  │   └── hashCode / lock state / GC age / …  │
│  └── Class Pointer (4 bytes, CompressedOops) │
│      └── → Klass（类元数据，在 Metaspace）    │
├──────────────────────────────────────────────┤
│  Instance Data                               │
│  ├── 父类字段（按类型对齐）                   │
│  └── 本类字段                                │
├──────────────────────────────────────────────┤
│  Padding（补齐到 8 字节倍数）                 │
└──────────────────────────────────────────────┘
```

数组对象额外有一个 4 字节的 `length` 字段。

---

## 5. GC 与拷贝的交互

- **拷贝产生更多对象** → 增加 GC 压力，尤其是频繁深拷贝会导致 Eden 快速填满，触发更多 Minor GC。
- **短命对象（ephemeral objects）** → 年轻代 GC 成本相对低，大量临时拷贝对象通常在 Minor GC 时回收，不会晋升 Old Gen（前提：不被长期持有）。
- **序列化深拷贝的代价** → 序列化/反序列化会产生大量中间字节数组，对 GC 不友好；Kryo 等框架使用对象池减少分配。
- **大数组拷贝** → 使用 `Arrays.copyOf()` 或 `System.arraycopy()`，底层是 native 内存拷贝（`memmove`），比 Java 循环快得多，但仍是浅拷贝。

---

## 6. 线程安全与拷贝

```
Thread A                Thread B
  │                        │
  ▼                        ▼
original.list.add(x)    original.list.get(0)
  │                        │
  └──── 浅拷贝时，copy.list 和 original.list 是同一对象 ────┘
                      → 竞态条件！
```

- **浅拷贝**：多线程共享引用字段，存在数据竞争。
- **深拷贝**：新对象的引用字段完全独立，线程安全（前提：拷贝操作本身是原子的，或在安全点执行）。
- **不可变对象**（`String`、`Integer`、`LocalDate` 等）：字段指向不可变对象时，浅拷贝是安全的，因为对象状态不可变。

---

## 关联

- [[concepts/java-copy]] — 浅拷贝与深拷贝的实现详解
- [[concepts/jdbctemplate-resource-management]] — Java 资源管理
