#!/usr/bin/env bash
# Redaction gate for this repository. Runs in CI on every push and locally.
#
# Fails when a committed file contains something POLICY.md says must never be
# published. Deliberately conservative: a false positive costs one line in
# redaction/allow.txt, a false negative costs a victim.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ALLOW_FILE="redaction/allow.txt"
fail=0
report() { printf 'FAIL %s:%s %s\n' "$1" "$2" "$3"; fail=1; }

# Files to scan: every file that would be committed (tracked + staged +
# untracked-but-not-ignored), so the gate works before the first commit too.
if git rev-parse --git-dir >/dev/null 2>&1; then
  mapfile -t FILES < <(git ls-files --cached --others --exclude-standard)
else
  mapfile -t FILES < <(find . -type f -not -path './.git/*' | sed 's|^\./||')
fi

# The checker, the allow-list and .gitignore necessarily contain the patterns
# they list. Nothing else is exempt.
is_scanner() { case "$1" in scripts/*|redaction/*|.gitignore) return 0;; esac; return 1; }

allow_emails() { [ -f "$ALLOW_FILE" ] && grep -vE '^\s*(#|$)' "$ALLOW_FILE" || true; }
ALLOWED_EMAILS="$(allow_emails)"

# 1. Source code must never be published here.
for f in "${FILES[@]}"; do
  case "$f" in
    *.go|go.mod|go.sum|*.rs|*.c|*.h|*.py) report "$f" 0 "source-code file in a reports-only repository";;
  esac
done

for f in "${FILES[@]}"; do
  [ -f "$f" ] || continue
  is_scanner "$f" && continue

  # Skip binaries: screenshots are checked by size/extension only.
  if ! grep -Iq . "$f" 2>/dev/null; then
    size=$(wc -c < "$f")
    case "$f" in
      *.png|*.jpg|*.jpeg|*.svg) [ "$size" -gt 5242880 ] && report "$f" 0 "image over 5 MiB";;
      *) report "$f" 0 "binary file (only images are allowed)";;
    esac
    continue
  fi

  # 2. Emails, unless explicitly allow-listed (public abuse desks, examples).
  while IFS= read -r line; do
    ln="${line%%:*}"; text="${line#*:}"
    for email in $(printf '%s' "$text" | grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'); do
      if ! printf '%s\n' "$ALLOWED_EMAILS" | grep -qxF "$email"; then
        report "$f" "$ln" "email address: $email"
      fi
    done
  done < <(grep -nE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$f" || true)

  # 3. Private / loopback / link-local addresses.
  while IFS= read -r line; do
    ln="${line%%:*}"; text="${line#*:}"
    for ip in $(printf '%s' "$text" | grep -oE '\b(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3}|127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|169\.254\.[0-9]{1,3}\.[0-9]{1,3})\b'); do
      report "$f" "$ln" "private/internal address: $ip"
    done
  done < <(grep -nE '\b(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.|127\.|169\.254\.)' "$f" || true)

  # 4. Key material and token shapes.
  grep -nE 'BEGIN [A-Z ]*PRIVATE KEY' "$f" | while read -r ln _; do report "$f" "$ln" "private key block"; done
  grep -nE '(gh[pousr]_[A-Za-z0-9]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.)' "$f" \
    | while read -r ln _; do report "$f" "$ln" "token-shaped string"; done

  # 5. Absolute home paths and SSH material references.
  grep -nE '(/home/[a-z0-9_.-]+/|/Users/[A-Za-z0-9_.-]+/|\.ssh/|id_rsa|id_ed25519|\.pem\b)' "$f" \
    | while read -r ln _; do report "$f" "$ln" "home path or SSH material reference"; done
done

# 6. Commit metadata: dates are normalized to UTC so the author's timezone is
#    not published with every commit.
if git rev-parse --git-dir >/dev/null 2>&1; then
  while read -r line; do
    case "$line" in
      *+0000) ;;
      *) report "commit-metadata" 0 "non-UTC commit date (timezone leak): $line" ;;
    esac
  done < <(git log --all --format='%ai')
fi

if [ "$fail" -eq 0 ]; then
  echo "redaction check: OK (${#FILES[@]} files)"
else
  echo "redaction check: FAILED — fix the lines above or extend redaction/allow.txt"
fi
exit "$fail"
