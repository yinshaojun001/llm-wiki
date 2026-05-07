---
title: Java 深拷贝与浅拷贝
tags: [concept, java, clone, object-copy, deep-copy, shallow-copy]
date: 2026-04-13
sources: [sources/daily-2026-technical.md]
---

# Java 深拷贝与浅拷贝

> 前置知识：[[concepts/java-memory-model]] — 理解堆/栈/引用是读懂本页的基础。

---

## 1. 核心概念

### 赋值（Assignment）≠ 拷贝

```java
Person a = new Person("Alice", 30);
Person b = a;  // 仅复制引用，不创建新对象
b.setName("Bob");
System.out.println(a.getName()); // "Bob" ← a 和 b 指向同一对象
```

```
Stack          Heap
  a ──────────► Person@A1B2 { name:"Bob", age:30 }
  b ──────────►
```

### 浅拷贝（Shallow Copy）

新建一个对象，将原对象的每个字段**逐字节复制**到新对象：
- **基本类型字段**（int, double, boolean 等）：值被完整复制，互相独立。
- **引用类型字段**（Object、数组、集合等）：复制引用的值（即地址），新旧对象共享同一个子对象。

```
Stack          Heap
  orig ──────► Person@A1 { name → String@S1("Alice"), scores → int[]@L1 }
  copy ──────► Person@A2 { name → String@S1("Alice"), scores → int[]@L1 }
                                                                  ▲
                             两个 Person 对象的 scores 字段 ────────┘
                             指向同一个 int[] 数组
```

### 深拷贝（Deep Copy）

递归地复制对象图（object graph）中的所有节点，新对象与原对象完全独立。

```
Stack          Heap
  orig ──────► Person@A1 { name → String@S1, scores → int[]@L1 }
  copy ──────► Person@A2 { name → String@S2, scores → int[]@L2 }
                              ↑ 新 String（不可变所以通常共享）  ↑ 全新数组
```

---

## 2. Object.clone() 的工作原理

`Object.clone()` 是 JVM 原生方法（native），实现为：
1. 分配一块与原对象相同大小的内存。
2. 将原对象的字节（包括对象头中的字段部分）**按位复制**到新内存。
3. 返回新对象的引用。

这就是为什么它天然是**浅拷贝**：它只复制字段本身的值（对引用字段而言就是地址值），不递归复制引用指向的对象。

### 使用 clone() 的约定（Cloneable 接口）

`Cloneable` 是一个标记接口（marker interface），不含任何方法。若类未实现 `Cloneable` 而调用 `super.clone()`，会抛出 `CloneNotSupportedException`。

```java
public class Person implements Cloneable {
    private String name;
    private int age;
    private int[] scores; // 引用类型字段

    @Override
    protected Person clone() throws CloneNotSupportedException {
        return (Person) super.clone(); // 浅拷贝：scores 仍共享
    }
}
```

### 浅拷贝时哪些字段受影响

| 字段类型 | 浅拷贝后行为 | 是否独立 |
|---------|------------|---------|
| `int`, `long`, `double` 等基本类型 | 值完整复制 | 是 |
| `String` | 复制引用，但 String 是不可变的，实际安全 | 实际安全 |
| `Integer`, `Long` 等包装类 | 复制引用，但包装类不可变 | 实际安全 |
| `int[]`, `String[]` 等数组 | 复制引用，共享同一个数组 | 否 ⚠️ |
| `List<E>`, `Map<K,V>` 等集合 | 复制引用，共享集合及其元素 | 否 ⚠️ |
| 自定义可变类 | 复制引用，共享对象 | 否 ⚠️ |

---

## 3. 浅拷贝的典型 Bug

```java
public class Team implements Cloneable {
    private String name;
    private List<String> members;

    @Override
    protected Team clone() throws CloneNotSupportedException {
        return (Team) super.clone(); // 浅拷贝！
    }
}

Team t1 = new Team("Alpha", new ArrayList<>(List.of("Alice", "Bob")));
Team t2 = t1.clone();

t2.getMembers().add("Charlie"); // 修改 t2 的 members
System.out.println(t1.getMembers()); // ["Alice", "Bob", "Charlie"] ← t1 也被改了！
```

原因：`t1.members` 和 `t2.members` 是同一个 `ArrayList` 对象。

---

## 4. 不可变对象的特殊性

`String`、`Integer`、`LocalDate` 等不可变（immutable）类的实例，一旦创建就无法修改。因此：

```java
// 浅拷贝时 name 字段共享，但无论谁"修改" name
// 实际上都是让引用指向一个新的 String 对象，原对象不变
copy.setName("Bob"); // → copy.name = new String("Bob")，不影响 orig.name
```

不可变对象在浅拷贝场景中是**安全的**，因为它们没有可变状态。这也是为什么 Java 鼓励 Value Object（VO）设计为不可变的。

---

## 5. 深拷贝实现方式

### 方式 1：手动实现 Cloneable（推荐用于简单场景）

```java
public class Person implements Cloneable {
    private String name;         // String 不可变，无需特殊处理
    private int age;             // 基本类型，自动复制
    private int[] scores;        // 数组，需要手动深拷贝
    private Address address;     // 自定义类，需要 Address 也实现 clone()

    @Override
    protected Person clone() throws CloneNotSupportedException {
        Person cloned = (Person) super.clone(); // 先浅拷贝
        cloned.scores = this.scores.clone();    // 数组的 clone() 是浅拷贝（对 int[] 是深拷贝，因为元素是基本类型）
        cloned.address = this.address.clone();  // Address 也需实现 Cloneable
        return cloned;
    }
}

public class Address implements Cloneable {
    private String city;
    private String street;

    @Override
    protected Address clone() throws CloneNotSupportedException {
        return (Address) super.clone(); // String 不可变，浅拷贝即可
    }
}
```

问题：
- 每个引用类型字段都需手动处理，容易遗漏。
- 链式 `clone()` 脆弱，继承层次深时维护困难。
- `CloneNotSupportedException` 是 checked exception，API 不友好。

### 方式 2：拷贝构造器（Copy Constructor）— 推荐

Joshua Bloch（Effective Java）推荐用拷贝构造器替代 `clone()`。

```java
public class Person {
    private String name;
    private int age;
    private List<String> hobbies;
    private Address address;

    // 拷贝构造器
    public Person(Person source) {
        this.name = source.name;           // String 不可变，直接赋值
        this.age = source.age;             // 基本类型，直接赋值
        this.hobbies = new ArrayList<>(source.hobbies); // 创建新 List，元素是 String（不可变），安全
        this.address = new Address(source.address);     // Address 也提供拷贝构造器
    }
}

public class Address {
    private String city;
    private String street;

    public Address(Address source) {
        this.city = source.city;     // String 不可变
        this.street = source.street;
    }
}

// 使用
Person p1 = new Person("Alice", 30, List.of("reading"), new Address("Beijing", "Main St"));
Person p2 = new Person(p1); // 深拷贝
```

优点：
- 代码明确，不依赖 JVM 内部机制。
- 不需要实现 `Cloneable`，无 checked exception。
- 可以做类型转换（如从接口实现类拷贝）。

### 方式 3：序列化/反序列化深拷贝

利用 Java 序列化机制：将对象序列化为字节流，再反序列化为新对象。

```java
import java.io.*;

public class DeepCopyUtil {
    @SuppressWarnings("unchecked")
    public static <T extends Serializable> T deepCopy(T original) {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            try (ObjectOutputStream oos = new ObjectOutputStream(baos)) {
                oos.writeObject(original);
            }
            ByteArrayInputStream bais = new ByteArrayInputStream(baos.toByteArray());
            try (ObjectInputStream ois = new ObjectInputStream(bais)) {
                return (T) ois.readObject();
            }
        } catch (IOException | ClassNotFoundException e) {
            throw new RuntimeException("Deep copy failed", e);
        }
    }
}

// 使用（所有涉及的类必须实现 Serializable）
Person copy = DeepCopyUtil.deepCopy(original);
```

**优点**：简单通用，自动处理对象图（包括循环引用）。

**缺点**：
- 所有类必须实现 `Serializable`（包括字段类型）。
- 性能差（IO 流、反射、字节数组分配），约比手动拷贝慢 10–100 倍。
- 不拷贝 `transient` 字段（可能是 bug）。
- 不拷贝静态字段（通常正确）。
- 存在安全风险（反序列化注入，生产环境要注意）。

### 方式 4：Kryo（第三方，高性能序列化）

[Kryo](https://github.com/EsotericSoftware/kryo) 是一个 Java 快速序列化框架，不需要实现 `Serializable`。

```xml
<!-- Maven 依赖 -->
<dependency>
    <groupId>com.esotericsoftware</groupId>
    <artifactId>kryo</artifactId>
    <version>5.6.0</version>
</dependency>
```

```java
import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.io.Input;
import com.esotericsoftware.kryo.io.Output;

public class KryoCopyUtil {
    // Kryo 不是线程安全的，用 ThreadLocal 或对象池
    private static final ThreadLocal<Kryo> kryoLocal = ThreadLocal.withInitial(() -> {
        Kryo kryo = new Kryo();
        kryo.setRegistrationRequired(false); // 不需要提前注册类
        return kryo;
    });

    @SuppressWarnings("unchecked")
    public static <T> T deepCopy(T original) {
        Kryo kryo = kryoLocal.get();
        return kryo.copy(original); // kryo.copy() 内部序列化+反序列化
    }
}
```

**Kryo 内置 `copy()` 方法**，比序列化到字节流再反序列化更快（直接在对象图上递归复制）。

性能对比（仅参考数量级）：

| 方式 | 相对速度 | 类约束 | 循环引用 |
|------|---------|-------|---------|
| 手动 clone() | 最快 | 需实现 Cloneable | 需手动处理 |
| 拷贝构造器 | 很快 | 无 | 需手动处理 |
| Java 序列化 | 慢（10–100x） | 需 Serializable | 自动支持 |
| Kryo copy() | 快（~2–5x vs Java序列化） | 无 | 自动支持 |
| Jackson（JSON 序列化） | 中等 | 需 getter/setter | 不支持（默认） |

### 方式 5：Apache Commons Lang — SerializationUtils

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.14.0</version>
</dependency>
```

```java
import org.apache.commons.lang3.SerializationUtils;

Person copy = SerializationUtils.clone(original); // 类型安全，但仍基于 Java 序列化
```

本质上是对 Java 序列化的封装，便利性高但性能与标准序列化一致。

### 方式 6：Jackson（JSON 深拷贝）

```java
import com.fasterxml.jackson.databind.ObjectMapper;

ObjectMapper mapper = new ObjectMapper();
Person copy = mapper.readValue(mapper.writeValueAsString(original), Person.class);
```

- 不需要 `Serializable`，但需要无参构造器和 getter/setter（或 Jackson 注解）。
- 性能一般，适用于已有 Jackson 依赖的项目。
- 不支持循环引用（默认），不拷贝非 JSON 可序列化字段。

---

## 6. 复杂对象图示例

### 场景：List 包含可变对象

```java
public class Team {
    private String name;
    private List<Player> players; // List 中的 Player 是可变类

    // 浅拷贝
    public Team shallowCopy() throws CloneNotSupportedException {
        return (Team) super.clone(); // players 列表共享！
    }

    // 深拷贝（拷贝构造器方式）
    public Team(Team source) {
        this.name = source.name;
        // 创建新 List，对每个 Player 也做深拷贝
        this.players = source.players.stream()
            .map(Player::new) // Player 需有拷贝构造器
            .collect(Collectors.toList());
    }
}
```

### 浅拷贝时的内存状态

```
orig.players ──► ArrayList@L1 ──► [Player@P1, Player@P2, Player@P3]
copy.players ──► ArrayList@L1 ──►         (same array!)
                                            ▲▲▲
                         修改 copy.players.get(0).setName("X")
                         会同时修改 orig.players.get(0)
```

### 深拷贝后的内存状态

```
orig.players ──► ArrayList@L1 ──► [Player@P1, Player@P2, Player@P3]
copy.players ──► ArrayList@L2 ──► [Player@P4, Player@P5, Player@P6]
                                    ↑↑↑ 全新对象，完全独立
```

---

## 7. 嵌套对象的深拷贝注意事项

```java
// 错误：只深拷贝了 List 本身，没有深拷贝 List 内的元素
public Team buggyDeepCopy() throws CloneNotSupportedException {
    Team cloned = (Team) super.clone();
    cloned.players = new ArrayList<>(this.players); // 新 List，但元素仍是原 Player 引用！
    return cloned;
}

// 正确：对 List 内每个元素也做深拷贝
public Team correctDeepCopy() throws CloneNotSupportedException {
    Team cloned = (Team) super.clone();
    cloned.players = this.players.stream()
        .map(p -> {
            try { return p.clone(); }
            catch (CloneNotSupportedException e) { throw new RuntimeException(e); }
        })
        .collect(Collectors.toList());
    return cloned;
}
```

---

## 8. 如何选择拷贝方式

```
需要深拷贝？
│
├── 对象图简单（1–2 层，字段类型明确）
│   └── → 拷贝构造器（最清晰，推荐）
│
├── 对象图复杂（多层嵌套，动态结构）
│   ├── 性能要求高，不能引入 Serializable
│   │   └── → Kryo copy()
│   ├── 已有 Java Serializable
│   │   └── → SerializationUtils.clone() 或手写序列化工具
│   └── 已有 Jackson，类有 getter/setter
│       └── → Jackson readValue(writeValueAsString())
│
└── 框架/库代码，不想依赖外部
    └── → 手动 Cloneable + super.clone()（最原始，最脆弱）
```

---

## 9. 常见陷阱汇总

| 陷阱 | 描述 | 修复 |
|------|------|------|
| clone() 忘记调用 super.clone() | 返回 `new ClassName()` 而不是 `super.clone()`，会破坏继承链 | 始终用 `super.clone()` 开头 |
| 只拷贝了 List，未拷贝 List 内元素 | `new ArrayList<>(original)` 是浅拷贝 | 流式深拷贝每个元素 |
| 认为 String 需要深拷贝 | String 不可变，浅拷贝安全 | 无需处理 |
| final 字段无法在 clone() 后赋值 | `super.clone()` 后不能修改 final 字段 | 用拷贝构造器代替 |
| 循环引用导致 StackOverflow | 递归 clone() 遇到 A→B→A 循环 | 用序列化或维护 visited 集合 |
| Serializable 深拷贝漏掉 transient 字段 | transient 字段不参与序列化 | 检查每个 transient 字段是否需要拷贝 |

---

## 关联

- [[concepts/java-memory-model]] — JVM 内存结构、堆/栈、引用 vs 指针、GC
- [[concepts/jdbctemplate-resource-management]] — Java 资源管理陷阱
