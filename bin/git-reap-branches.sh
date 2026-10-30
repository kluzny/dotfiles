#!/usr/bin/env bash
# Deletes local branches already merged into <remote>/<base>
#
# Usage: git reap-branches [--base <ref>] [--remote <name>] [--keep <glob>]... [--dry-run]
#   --base <ref>     Branch to reap against (default: <remote>/HEAD, then main, then master).
#   --remote <name>  Remote to fetch and compare against (default: origin).
#   --keep <glob>    Never reap branches matching this glob; repeatable. Quote it.
#   --dry-run        Run every check and print what would be reaped, deleting nothing.
#
# Deletes refs only: never switches branches, moves other refs, pushes, or
# touches a working tree. Branches checked out in a worktree get a warning with
# the command that reaps them by hand. Exits 1 when anything was left behind
# with a warning, 2 on a fatal error.

set -euo pipefail

usage() {
  sed -n '2,13s/^# \{0,1\}//p' "$0"
}

die() {
  echo "git-reap-branches: $*" >&2
  exit 2
}

base=""
remote="origin"
keeps=()
dry_run=0

while [ $# -gt 0 ]; do
  case "$1" in
    --base)
      base="${2:?--base requires a branch name}"
      shift 2
      ;;
    --base=*)
      base="${1#--base=}"
      shift
      ;;
    --remote)
      remote="${2:?--remote requires a remote name}"
      shift 2
      ;;
    --remote=*)
      remote="${1#--remote=}"
      shift
      ;;
    --keep)
      keeps+=("${2:?--keep requires a glob}")
      shift 2
      ;;
    --keep=*)
      keeps+=("${1#--keep=}")
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      die "unknown argument: $1"
      ;;
  esac
done

git rev-parse --git-dir >/dev/null 2>&1 || die "not inside a git repository"

for marker in rebase-merge rebase-apply MERGE_HEAD CHERRY_PICK_HEAD REVERT_HEAD; do
  if [ -e "$(git rev-parse --git-path "$marker")" ]; then
    die "$marker exists; finish or abort the operation in progress first"
  fi
done

git fetch --prune "$remote" || die "fetch from $remote failed; nothing deleted"

if [ -z "$base" ]; then
  base="$(git symbolic-ref --quiet --short "refs/remotes/$remote/HEAD" 2>/dev/null || true)"
  base="${base#"$remote"/}"
fi
if [ -z "$base" ]; then
  for candidate in main master; do
    if git show-ref --verify --quiet "refs/remotes/$remote/$candidate"; then
      base="$candidate"
      break
    fi
  done
fi
[ -n "$base" ] || die "no $remote/HEAD, $remote/main or $remote/master; pass --base"

# compare against the remote ref so a stale or locally-advanced base can't
# make an unpushed branch look merged
base_ref="refs/remotes/$remote/$base"
git show-ref --verify --quiet "$base_ref" || die "$remote/$base does not exist"

here="$(git rev-parse --show-toplevel 2>/dev/null || true)"

# parallel arrays because bash 3.2 has no associative arrays; detached and bare
# entries have no branch line and are skipped
wt_branches=()
wt_paths=()
wt_path=""
while IFS= read -r line; do
  case "$line" in
    "worktree "*) wt_path="${line#worktree }" ;;
    "branch refs/heads/"*)
      wt_branches+=("${line#branch refs/heads/}")
      wt_paths+=("$wt_path")
      ;;
  esac
done < <(git worktree list --porcelain)

worktree_for() {
  local i=0
  while [ "$i" -lt "${#wt_branches[@]}" ]; do
    if [ "${wt_branches[$i]}" = "$1" ]; then
      printf '%s\n' "${wt_paths[$i]}"
      return 0
    fi
    i=$((i + 1))
  done
  return 1
}

is_protected() {
  local glob
  case "$1" in
    main | master | develop) return 0 ;;
  esac
  if [ "$1" = "$base" ]; then
    return 0
  fi
  # the ${a[@]+...} guard keeps an empty array from tripping `set -u` on bash 3.2
  for glob in ${keeps[@]+"${keeps[@]}"}; do
    # shellcheck disable=SC2254 # unquoted on purpose so the glob matches
    case "$1" in
      $glob) return 0 ;;
    esac
  done
  return 1
}

# buffered so output prints grouped by classification instead of ref order
skip_lines=()
warn_lines=()
reap_lines=()
restores=()

line() {
  printf -v formatted '%-10s %-28s %s' "$1" "$2" "$3"
}

skip() {
  line skipped "$1" "$2"
  skip_lines+=("$formatted")
}

warn() {
  line warning "$1" "$2"
  warn_lines+=("$formatted")
}

reap() {
  line "$1" "$2" "$3"
  reap_lines+=("$formatted")
}

# snapshot first so deletions don't race the ref listing
branches="$(git for-each-ref --format='%(refname)' refs/heads)"

while IFS= read -r ref; do
  [ -n "$ref" ] || continue
  branch="${ref#refs/heads/}"

  if is_protected "$branch"; then
    skip "$branch" "protected"
    continue
  fi

  ahead="$(git rev-list --count "$base_ref..$ref")"
  if [ "$ahead" -ne 0 ]; then
    skip "$branch" "not merged into $remote/$base, commits: $ahead"
    continue
  fi

  if wt="$(worktree_for "$branch")"; then
    state=""
    if ! status="$(git --no-optional-locks -C "$wt" status --porcelain 2>/dev/null)"; then
      state=" (status unavailable)"
    elif [ -n "$status" ]; then
      state=" (dirty)"
    fi
    reap_cmd="git branch -D $(printf '%q' "$branch")"
    if [ "$wt" = "$here" ]; then
      warn "$branch" "merged but checked out here$state; run: git switch $(printf '%q' "$base") && $reap_cmd"
    else
      warn "$branch" "merged but checked out$state; run: git -C $(printf '%q' "$wt") switch $(printf '%q' "$base") && $reap_cmd"
    fi
    continue
  fi

  sha="$(git rev-parse "$ref")"
  if [ "$dry_run" -eq 1 ]; then
    reap reap-ok "$branch" "${sha:0:7}"
    continue
  fi

  # -D because the ancestry check above is authoritative; -d compares against
  # the upstream or HEAD and refuses wrongly from a feature branch
  if err="$(git branch -D "$branch" 2>&1 >/dev/null)"; then
    reap !reaped "$branch" "${sha:0:7}"
    restores+=("git branch $(printf '%q' "$branch") $sha")
  else
    warn "$branch" "git branch -D failed: $err"
  fi
done <<EOF
$branches
EOF

# the ${a[@]+...} guard keeps an empty array from tripping `set -u` on bash 3.2
for entry in ${skip_lines[@]+"${skip_lines[@]}"}; do
  echo "$entry"
done
for entry in ${warn_lines[@]+"${warn_lines[@]}"}; do
  echo "$entry" >&2
done
for entry in ${reap_lines[@]+"${reap_lines[@]}"}; do
  echo "$entry"
done

reaped=${#reap_lines[@]}
skipped=${#skip_lines[@]}
warned=${#warn_lines[@]}

echo
if [ "$dry_run" -eq 1 ]; then
  echo "would reap $reaped, skipped $skipped, warnings $warned (dry run, nothing deleted)"
else
  echo "reaped $reaped, skipped $skipped, warnings $warned"
fi

if [ "${#restores[@]}" -gt 0 ]; then
  echo
  echo "restore with:"
  printf '%s\n' "${restores[@]}"
fi

[ "$warned" -eq 0 ] || exit 1
