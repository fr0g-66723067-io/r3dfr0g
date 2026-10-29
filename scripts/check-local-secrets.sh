#!/usr/bin/env bash
# Local pre-push check for values that must never be committed here at all.
#
# The deny-list lives OUTSIDE this repository (~/.config/r3dfr0g-reports/deny.txt)
# because it contains the plaintext vantage address and reporter address — if it
# were tracked, the check itself would leak what it protects.
#
# deny.txt format: one literal per line, '#' comments, matched case-insensitively.
# Run this before every push; CI cannot run it (it has no deny-list, by design).
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DENY="${R3DFR0G_REPORTS_DENY:-$HOME/.config/r3dfr0g-reports/deny.txt}"
fail=0

if [ ! -f "$DENY" ]; then
  echo "note: no deny-list at $DENY (skipping literal check; run scripts/check-redactions.sh)"
else
  while IFS= read -r literal; do
    case "$literal" in ''|'#'*) continue;; esac
    hits=$(grep -rniF --exclude-dir=.git --exclude-dir=scripts -- "$literal" . || true)
    if [ -n "$hits" ]; then
      echo "FAIL literal from deny-list: '$literal'"
      printf '%s\n' "$hits" | sed 's/^/    /'
      fail=1
    fi
  done < "$DENY"
fi

if [ "$fail" -eq 0 ]; then echo "local secret check: OK"; else echo "local secret check: FAILED"; fi
exit "$fail"
