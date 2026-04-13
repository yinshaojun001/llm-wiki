---
title: JdbcTemplate 资源管理
tags: [concept, java, spring, jdbc, resource-management]
date: 2026-04-09
sources: [sources/58-experience.md]
---

# JdbcTemplate 资源管理

> Spring JdbcTemplate 统一管理 Connection 和 Statement 的生命周期，回调内不需要也不能手动关闭。

## 核心结论

在 `PreparedStatementCreator` 回调里直接 return PreparedStatement，**不要**用 try-with-resources 包裹。

```java
// 正确：JdbcTemplate 负责关闭
jdbcTemplate.update(connection -> {
    PreparedStatement ps = connection.prepareStatement(sql, RETURN_GENERATED_KEYS);
    ps.setInt(1, batch.getType());
    return ps;  // 直接 return，JdbcTemplate 的 finally 会关闭
}, keyHolder);
```

```java
// 错误：Sonar AI 修复建议，会导致 Statement closed 异常
jdbcTemplate.update(connection -> {
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        return ps;  // ps 在 return 前已被关闭！
    }
}, keyHolder);
```

## JdbcTemplate 内部执行顺序

1. 从连接池获取 Connection
2. 调用你的回调创建 PreparedStatement
3. 执行 SQL
4. **finally 块：自动关闭 Statement，归还 Connection**

## 实际教训

Sonar 的"Resources should be closed"警告在此场景下是**误报**。AI 自动修复（try-with-resources）会让 Statement 在 JdbcTemplate 使用前就被关闭，抛出 `java.sql.SQLException: Statement closed`。

> **框架边界内的资源，由框架管理，不要双重关闭。**
