---
title: Java 深拷贝与浅拷贝
tags: [concept, java, clone, object-copy]
date: 2026-04-09
sources: [sources/daily-2026-technical.md]
---

# Java 深拷贝与浅拷贝

## 定义

- **浅拷贝**：只复制对象指针，新旧对象共享同一块引用类型内存。修改其中一个的引用字段，另一个也会变。
- **深拷贝**：完整复制对象及其所有引用类型字段，新旧对象完全独立。

## 快速判断

```java
// 浅拷贝：clone() 默认实现
ShallowCloneExample e2 = e1.clone();
e1.set(2, 222);
System.out.println(e2.get(2)); // 222 ← 受影响

// 深拷贝：clone() 内手动复制引用字段
@Override
protected DeepCloneExample clone() {
    DeepCloneExample result = new DeepCloneExample();
    result.arr = this.arr.clone(); // 复制数组
    return result;
}
```

## 关联

- [[concepts/jdbctemplate-resource-management]]（同为 Java 资源管理相关陷阱）
