#!/usr/bin/env bash
# 提交前的洩漏檢查：掃描所有追蹤中的檔案（排除圖片 base64 內容）是否含有
# 電子郵件、公司名稱、API 金鑰／權杖、私鑰、內網位址等不該出現在公開倉庫的內容。
# 用法：bash scripts/check-leaks.sh   （有發現時回傳非 0）
set -u
cd "$(git rev-parse --show-toplevel)"
PATTERNS='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}|(?i)foxconn|fih-|api[_-]?key|secret[_-]?key|access[_-]?token|password\s*[:=]|passwd|bearer\s+[A-Za-z0-9._-]{16,}|sk-[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{12,}|ghp_[A-Za-z0-9]{20,}|xox[baprs]-|BEGIN (RSA|EC|OPENSSH|PGP) PRIVATE|\b(192\.168|10|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]+\.[0-9]+|\.corp\b|\.internal\b'
status=0
while IFS= read -r f; do
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.ico|*.webp|scripts/check-leaks.sh) continue;; esac
  # 去掉 data:image base64 內容再比對，避免圖片資料誤判
  if sed -E 's#data:image/[a-z]+;base64,[A-Za-z0-9+/=]+##g' "$f" | grep -nP -o "$PATTERNS" | grep -v "noreply@anthropic.com\|users.noreply.github.com" | head -5 | sed "s#^#$f:#" | grep .; then status=1; fi
done < <(git -c core.quotepath=false ls-files)
# 檢查即將提交的作者身分不是公司信箱
email="$(git config user.email || true)"
if printf '%s' "$email" | grep -Eiq 'foxconn|fih'; then echo "git user.email 為公司信箱：$email"; status=1; fi
[ $status -eq 0 ] && echo "check-leaks: 未發現洩漏" || echo "check-leaks: 發現可疑內容，請處理後再提交"
exit $status
