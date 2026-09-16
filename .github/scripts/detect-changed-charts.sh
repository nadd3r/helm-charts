#!/usr/bin/env bash
#
# Detects which charts under charts/<name> had their Chart.yaml `version`
# field bumped between two commits, and emits a JSON matrix (for use in a
# GitHub Actions `strategy.matrix.include`) containing only those charts.
#
# Usage: detect-changed-charts.sh <before-sha> <after-sha>
#
# Requires: git, yq (mikefarah/yq v4), jq

set -euo pipefail

BEFORE="${1:-}"
AFTER="${2:-}"

# Git's well-known empty tree hash. Used when BEFORE is the all-zero SHA
# GitHub sends on a branch's very first push (nothing to diff against).
EMPTY_TREE_SHA="4b825dc642cb6eb9a060e54bf8d69288fbee4904"

if [[ -z "$BEFORE" || "$BEFORE" == "0000000000000000000000000000000000000000" ]]; then
  BEFORE="$EMPTY_TREE_SHA"
fi

# List unique immediate subdirectories under charts/ that changed at all
# (added, modified, or deleted files) between BEFORE and AFTER.
mapfile -t CHANGED_DIRS < <(
  git diff --name-only "$BEFORE" "$AFTER" -- charts/ \
    | awk -F/ 'NF>=2 {print $1"/"$2}' \
    | sort -u
)

MATRIX="[]"

if [[ "${#CHANGED_DIRS[@]}" -eq 0 ]]; then
  echo "No changes under charts/ detected."
else
  for dir in "${CHANGED_DIRS[@]}"; do
    [[ -z "$dir" ]] && continue

    chart_name="$(basename "$dir")"
    chart_yaml="$dir/Chart.yaml"

    if [[ ! -f "$chart_yaml" ]]; then
      echo "::notice::Skipping '${chart_name}' — Chart.yaml not found at HEAD (chart likely deleted)."
      continue
    fi

    new_version="$(yq eval '.version' "$chart_yaml")"

    # Look up the version at the BEFORE commit. This will be empty if the
    # chart (or its Chart.yaml) didn't exist yet, which we treat as "new chart".
    old_version="$(git show "${BEFORE}:${chart_yaml}" 2>/dev/null | yq eval '.version' - 2>/dev/null || true)"

    if [[ -z "$old_version" || "$old_version" == "null" ]]; then
      echo "::notice::'${chart_name}' is a new chart (version ${new_version}) — will publish."
      MATRIX="$(jq -c --arg name "$chart_name" --arg path "$dir" --arg version "$new_version" \
        '. + [{"name": $name, "path": $path, "version": $version}]' <<<"$MATRIX")"
    elif [[ "$new_version" != "$old_version" ]]; then
      echo "::notice::'${chart_name}' version bumped (${old_version} -> ${new_version}) — will publish."
      MATRIX="$(jq -c --arg name "$chart_name" --arg path "$dir" --arg version "$new_version" \
        '. + [{"name": $name, "path": $path, "version": $version}]' <<<"$MATRIX")"
    else
      echo "::warning::Skipping '${chart_name}' — files changed but version was not bumped (still ${new_version})."
    fi
  done
fi

echo "Resulting matrix: ${MATRIX}"
echo "matrix=${MATRIX}" >> "$GITHUB_OUTPUT"