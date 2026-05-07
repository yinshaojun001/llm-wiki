# 笔记同步流程

在 Obsidian 里编辑完笔记后，将更新同步到 GitHub：

## 快速同步（一行命令）

```bash
cd /Users/a58/Desktop/llm-wiki
cp -r "/Users/a58/Documents/Obsidian Vault/llm-wiki" wiki.new && rm -rf wiki && mv wiki.new wiki
git add wiki CLAUDE.md
git commit -m "docs: update wiki notes from Obsidian"
git push origin main
```

## 分步操作

1. **复制笔记内容**
   ```bash
   # 删除本地 symlink，复制最新内容
   rm wiki
   cp -r "/Users/a58/Documents/Obsidian Vault/llm-wiki" wiki
   ```

2. **检查变更**
   ```bash
   git status
   ```

3. **提交**
   ```bash
   git add wiki CLAUDE.md
   git commit -m "docs: update wiki notes"
   ```

4. **推送到 GitHub**
   ```bash
   git push origin main
   ```

5. **恢复 symlink**（如需要在本地继续编辑）
   ```bash
   rm -rf wiki
   ln -s "/Users/a58/Documents/Obsidian Vault/llm-wiki" wiki
   ```

## 建议

- 定期执行同步（每周 1-2 次）
- 提交信息清晰（如 `docs: add new concept page` 或 `refactor: reorganize entities`）
- GitHub 上的内容作为备份，本地 Obsidian 是工作副本
