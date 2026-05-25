#!/usr/bin/env bash
# Removes git worktrees created by sweep and cleans up the temp directory.
# Usage: cleanup-worktrees.sh TMPDIR [PR_NUMBER ...]
#   If PR numbers given, removes sweep-pr-<N> worktrees under TMPDIR.
#   If no PR numbers, removes all sweep-pr-* worktrees under TMPDIR.
# Output: Status per worktree removal.
set -euo pipefail

SWEEP_TMPDIR="$1"
shift

if [ ! -d "$SWEEP_TMPDIR" ]; then
  echo "Directory $SWEEP_TMPDIR does not exist, nothing to clean"
  exit 0
fi

FAILURES=0

if [ $# -gt 0 ]; then
  # Remove specific PR worktrees
  for PR in "$@"; do
    WT="$SWEEP_TMPDIR/sweep-pr-$PR"
    if [ -d "$WT" ]; then
      if git worktree remove "$WT" --force 2>/dev/null; then
        echo "Removed: $WT"
      else
        echo "WARNING: could not remove $WT (dirty state)" >&2
        FAILURES=$((FAILURES + 1))
      fi
    fi
  done
else
  # Remove all sweep-pr-* worktrees
  for WT in "$SWEEP_TMPDIR"/sweep-pr-*; do
    [ -d "$WT" ] || continue
    if git worktree remove "$WT" --force 2>/dev/null; then
      echo "Removed: $WT"
    else
      echo "WARNING: could not remove $WT (dirty state)" >&2
      FAILURES=$((FAILURES + 1))
    fi
  done
fi

# Clean up temp directory if empty
rmdir "$SWEEP_TMPDIR" 2>/dev/null && echo "Removed temp dir: $SWEEP_TMPDIR" || true

# Prune stale worktree references
git worktree prune 2>/dev/null || true

if [ "$FAILURES" -gt 0 ]; then
  echo "$FAILURES worktrees could not be removed (manual cleanup needed)" >&2
  exit 1
fi

echo "Cleanup complete"
