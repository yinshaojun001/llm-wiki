#!/usr/bin/env bash
# sync.sh — 一键同步 Obsidian Vault 笔记到 GitHub
# 用法: ./sync.sh ["commit message"]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
VAULT_DIR="$HOME/Documents/Obsidian Vault/llm-wiki"
WIKI_LINK="$REPO_DIR/wiki"

cd "$REPO_DIR"

# 1. 检查 vault 目录
if [[ ! -d "$VAULT_DIR" ]]; then
  echo "❌ Obsidian Vault 目录不存在: $VAULT_DIR"
  exit 1
fi

# 2. 移除 symlink，复制最新内容
if [[ -L "$WIKI_LINK" ]]; then
  rm "$WIKI_LINK"
elif [[ -d "$WIKI_LINK" ]]; then
  rm -rf "$WIKI_LINK"
fi
cp -r "$VAULT_DIR" "$WIKI_LINK"

# 3. 检查是否有变更
if git diff --quiet && [[ -z "$(git status --porcelain)" ]]; then
  echo "✅ 没有变更，无需同步"
  # 恢复 symlink
  rm -rf "$WIKI_LINK"
  ln -s "$VAULT_DIR" "$WIKI_LINK"
  exit 0
fi

# 4. 统计变更
ADDED=$(git status --porcelain | grep -c '^??' || true)
MODIFIED=$(git status --porcelain | grep -c '^ M\|^M ' || true)
TOTAL=$((ADDED + MODIFIED))

# 5. 提交
MSG="${1:-docs: sync wiki from Obsidian ($TOTAL files changed)}"
git add .gitignore AGENTS.md SYNC.md wiki/
git commit -m "$MSG

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>"

# 6. 推送
git push origin main
echo "✅ 已同步 $TOTAL 个文件到 GitHub"

# 7. 恢复 symlink
rm -rf "$WIKI_LINK"
ln -s "$VAULT_DIR" "$WIKI_LINK"
