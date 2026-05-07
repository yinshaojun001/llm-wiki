---
title: Java 工程师算法指南
tags: [dsa, java, reference]
date: 2026-05-07
sources: [dsa/00-总览]
---

# Java 工程师算法指南

> 刷题时最常用的 Java API 和技巧

---

## 常用数据结构 API

### 数组

```java
int[] arr = new int[5];
Arrays.fill(arr, -1);               // 填充
Arrays.sort(arr);                    // 排序 O(n log n)
Arrays.sort(arr, (a, b) -> b - a);  // 降序
Arrays.copyOf(arr, newLength);       // 复制
Arrays.toString(arr);                // 转字符串
Arrays.stream(arr).sum();            // 求和
System.arraycopy(src, 0, dst, 0, n); // 高效复制
```

### ArrayList

```java
List<Integer> list = new ArrayList<>();
list.add(1);                         // 追加
list.get(0);                         // 随机访问
list.remove(list.size() - 1);        // 删除末尾
list.set(0, 99);                     // 修改
Collections.sort(list);              // 排序
Collections.reverse(list);           // 反转
new ArrayList<>(list);               // 复制
list.subList(0, 3);                  // 子列表（视图，不是副本）
```

### HashMap

```java
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.get("a");                        // 1
map.getOrDefault("b", 0);           // 0（不存在返回默认值）
map.containsKey("a");               // true
map.remove("a");
map.putIfAbsent("c", 3);           // 不存在才放入
map.computeIfAbsent("d", k -> k.length());  // 不存在才计算
for (Map.Entry<String, Integer> e : map.entrySet()) {
    e.getKey();  e.getValue();
}
```

### HashSet

```java
Set<Integer> set = new HashSet<>();
set.add(1);
set.contains(1);    // true
set.remove(1);
set.isEmpty();
new HashSet<>(set);  // 复制
// 交集/并集/差集
set1.retainAll(set2);  // 交集（修改 set1）
set1.addAll(set2);     // 并集
set1.removeAll(set2);  // 差集
```

### Deque（栈 + 队列）

```java
Deque<Integer> deque = new ArrayDeque<>();
// 当栈用
deque.push(1);    // 入栈
deque.pop();      // 出栈
deque.peek();     // 栈顶
// 当队列用
deque.offer(1);   // 入队
deque.poll();     // 出队
deque.peek();     // 队头
```

### PriorityQueue（堆）

```java
// 小顶堆
Queue<Integer> minHeap = new PriorityQueue<>();
// 大顶堆
Queue<Integer> maxHeap = new PriorityQueue<>(Comparator.reverseOrder());
// 自定义比较
Queue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);

pq.offer(1);
pq.poll();     // 弹出堆顶
pq.peek();     // 查看堆顶
```

### StringBuilder

```java
StringBuilder sb = new StringBuilder();
sb.append("hello");
sb.append(' ');
sb.append(123);
sb.toString();           // "hello 123"
sb.reverse();            // 原地反转
sb.charAt(0);            // 'h'
sb.deleteCharAt(0);      // 删除指定位置
sb.insert(0, "start");   // 插入
```

---

## 刷题模板

### 二分查找

```java
int binarySearch(int[] arr, int target) {
    int lo = 0, hi = arr.length - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) lo = mid + 1;
        else hi = mid - 1;
    }
    return -1;
}
```

### BFS

```java
void bfs(Node start) {
    Queue<Node> queue = new ArrayDeque<>();
    Set<Node> visited = new HashSet<>();
    queue.offer(start);
    visited.add(start);
    while (!queue.isEmpty()) {
        Node node = queue.poll();
        for (Node neighbor : node.neighbors) {
            if (!visited.contains(neighbor)) {
                visited.add(neighbor);
                queue.offer(neighbor);
            }
        }
    }
}
```

### DFS（递归）

```java
void dfs(Node node, Set<Node> visited) {
    visited.add(node);
    for (Node neighbor : node.neighbors) {
        if (!visited.contains(neighbor)) {
            dfs(neighbor, visited);
        }
    }
}
```

### 回溯

```java
void backtrack(List<List<Integer>> result, List<Integer> path, int[] nums, int start) {
    result.add(new ArrayList<>(path));
    for (int i = start; i < nums.length; i++) {
        path.add(nums[i]);
        backtrack(result, path, nums, i + 1);
        path.remove(path.size() - 1);
    }
}
```

---

## 调试技巧

```java
// 1. 打印数组
System.out.println(Arrays.toString(arr));

// 2. 打印二维数组
for (int[] row : matrix) System.out.println(Arrays.toString(row));

// 3. 打印链表
ListNode curr = head;
while (curr != null) {
    System.out.print(curr.val + " -> ");
    curr = curr.next;
}
System.out.println("null");

// 4. 打印树（层序）
Queue<TreeNode> q = new ArrayDeque<>();
q.offer(root);
while (!q.isEmpty()) {
    TreeNode node = q.poll();
    if (node == null) { System.out.print("null "); continue; }
    System.out.print(node.val + " ");
    q.offer(node.left);
    q.offer(node.right);
}
```

---

## 常见陷阱

| 陷阱 | 说明 |
|---|---|
| 整数溢出 | `int mid = lo + (hi - lo) / 2` 而不是 `(lo + hi) / 2` |
| 空指针 | 链表/树操作前先判 null |
| 数组越界 | `right` 初始值是 `n` 还是 `n-1`？ |
| 深拷贝 | `new ArrayList<>(path)` 而不是直接 `result.add(path)` |
| 浮点精度 | 用 `Math.abs(a - b) < 1e-6` 而不是 `a == b` |
| Comparator | `(a, b) -> a - b` 升序，`(a, b) -> b - a` 降序 |
