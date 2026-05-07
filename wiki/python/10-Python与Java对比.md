---
title: Python 与 Java 对比速查
tags: [python, java, reference]
date: 2026-05-07
sources: [python/00-总览]
---

# Python 与 Java 对比速查

> 面向 7 年 Java 工程师的快速类比表

---

## 核心哲学差异

| 维度 | Java | Python |
|---|---|---|
| 类型系统 | 静态强类型 | 动态强类型 |
| 编译/解释 | 编译为字节码 | 解释执行 |
| 访问控制 | public/private/protected | 约定（`_`/`__`） |
| 设计模式 | 大量需要 | 很多内置在语言里 |
| 代码风格 | 显式、冗长 | 隐式、简洁 |
| 错误处理 | 检查异常 | 都是运行时异常 |

---

## 语法对照

```python
# Java                          # Python
int x = 10;                     x = 10
String s = "hello";             s = "hello"
final int X = 10;               X = 10  (约定全大写)
if (x > 0) { ... }              if x > 0: ...
for (int i=0; i<10; i++) { }    for i in range(10): ...
while (cond) { }                while cond: ...
arr.length                      len(arr)
obj.method()                    obj.method()
System.out.println(x)           print(x)
String.format("%s:%d", s, i)    f"{s}:{i}"
try { } catch (E e) { }        try: ... except E as e: ...
new ArrayList<>()               []
new HashMap<>()                 {}
```

---

## 类型对照

| Java | Python | 说明 |
|---|---|---|
| `int` / `long` | `int` | Python 无上限 |
| `double` | `float` | 都是 64 位 |
| `String` | `str` | 不可变 |
| `boolean` | `bool` | `True`/`False` |
| `null` | `None` | 用 `is None` |
| `ArrayList` | `list` | 动态数组 |
| `HashMap` | `dict` | 哈希表 |
| `HashSet` | `set` | 集合 |
| 没有 | `tuple` | 不可变序列 |
| `record` | `@dataclass` | 数据类 |
| `interface` | `ABC` / 鸭子类型 | Python 更灵活 |
| `enum` | `enum.Enum` | 类似 |
| `Optional<T>` | `T \| None` | Python 3.10+ |

---

## OOP 对照

| Java | Python | 说明 |
|---|---|---|
| `this` | `self` | 显式传参 |
| 构造器 `Foo()` | `__init__(self)` | |
| `@Override` | 直接重写 | 无需注解 |
| `implements` | 鸭子类型 / 继承 ABC | Python 不需要声明 |
| `abstract class` | `ABC` + `@abstractmethod` | |
| `static` 方法 | `@staticmethod` | |
| `static` 工厂 | `@classmethod` | `cls` ≈ 类本身 |
| getter/setter | `@property` | Python 更自然 |
| `toString()` | `__str__` / `__repr__` | |
| `equals()` | `__eq__` | |
| `Comparable` | `__lt__` / `__gt__` | |
| `synchronized` | `threading.Lock` | 显式加锁 |

---

## 函数式编程

| Java | Python |
|---|---|
| `stream().map(x -> x*2)` | `[x*2 for x in lst]` |
| `stream().filter(x -> x>0)` | `[x for x in lst if x>0]` |
| `stream().collect(toList())` | `list(gen)` |
| `stream().reduce(0, Integer::sum)` | `sum(lst)` |
| `Optional.map(fn)` | `val if val else default` |
| `Comparator.comparing(...)` | `key=lambda x: x.name` |

---

## 并发对照

| Java | Python | 场景 |
|---|---|---|
| `Thread` | `threading.Thread` | 受 GIL 限制 |
| `ExecutorService` | `ThreadPoolExecutor` | I/O 密集 |
| `ForkJoinPool` | `ProcessPoolExecutor` | CPU 密集 |
| `CompletableFuture` | `asyncio` | 异步 I/O |
| `synchronized` | `Lock` / `RLock` | 互斥 |
| `volatile` | 没有直接对应 | |

---

## 工具链对照

| Java | Python | 用途 |
|---|---|---|
| Maven / Gradle | pip / poetry / uv | 包管理 |
| pom.xml / build.gradle | pyproject.toml / requirements.txt | 依赖声明 |
| JUnit | pytest | 测试 |
| Mockito | unittest.mock / pytest-mock | Mock |
| SLF4J | logging / loguru | 日志 |
| Jackson | json（内置）/ pydantic | JSON |
| Spring Boot | FastAPI / Flask | Web 框架 |
| IntelliJ | VS Code + Pylance | IDE |
| `javac` | `python` | 执行 |
| `jar` | `pip install` | 分发 |

---

## 踩坑速查

| 坑 | 说明 |
|---|---|
| `==` vs `is` | `==` 比值，`is` 比引用。永远用 `is None` 判断 None |
| 可变默认参数 | `def f(x=[])` 是错的！用 `def f(x=None)` |
| 缩进就是作用域 | Tab 和空格混用 = 灾难 |
| 浮点精度 | `0.1 + 0.2 != 0.3`（和 Java 一样） |
| `list.sort()` vs `sorted()` | 前者原地修改，后者返回新列表 |
| 字符串不可变 | `s[0] = "X"` 会报错，用 `s = "X" + s[1:]` |
| 全局变量 | 函数内修改需要 `global` 声明 |
