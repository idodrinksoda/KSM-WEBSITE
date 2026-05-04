#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

check_missing=1
check_spaces_staged=0
check_spaces_all=0

if [[ "${1:-}" == "--missing-only" ]]; then
  check_spaces_staged=0
  check_spaces_all=0
elif [[ "${1:-}" == "--spaces-only" ]]; then
  check_missing=0
  check_spaces_staged=1
elif [[ "${1:-}" == "--spaces-all" ]]; then
  check_missing=0
  check_spaces_all=1
fi

status=0

if [[ "$check_missing" -eq 1 ]]; then
  mapfile -t refs < <(grep -RhoE "assets/[A-Za-z0-9_./%\-]+" \
    --exclude-dir=.git \
    --exclude-dir=.vscode \
    --include='*.html' --include='*.css' --include='*.js' --include='*.md' --include='*.json' \
    . | sort -u)

  for p in "${refs[@]}"; do
    [[ -z "$p" ]] && continue
    [[ "$p" == *"..."* ]] && continue
    decoded="$(printf '%b' "${p//%/\\x}")"
    if [[ ! -e "$decoded" ]]; then
      echo "[asset-audit] Missing reference: $p -> $decoded"
      status=1
    fi
  done
fi

if [[ "$check_spaces_staged" -eq 1 ]]; then
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if [[ "$f" == *" "* ]]; then
      echo "[asset-audit] Staged asset filename has spaces: $f"
      status=1
    fi
  done < <(git diff --cached --name-only --diff-filter=AM | grep '^assets/' || true)
fi

if [[ "$check_spaces_all" -eq 1 ]]; then
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if [[ "$f" == *" "* ]]; then
      echo "[asset-audit] Filename has spaces: $f"
      status=1
    fi
  done < <(find assets -type f | sort)
fi

if [[ "$status" -eq 0 ]]; then
  echo "[asset-audit] OK"
fi

exit "$status"
