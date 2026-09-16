#!/usr/bin/env bash
#
# Detects which charts under charts/<name> had their Chart.yaml `version`
# field bumped between two commits, and emits a JSON matrix (for use in a
# GitHub Actions `strategy.matrix.include`) containing only those charts.
#
# Usage: detect-changed-charts.sh <before-sha> <after-sha>
#
# Requires: git, yq (mikefarah/yq v4), jq
#
# Exit codes:
#   0  one or more charts should be published, OR nothing under charts/ changed
#   1  charts/ changed but no Chart.yaml version was bumped (do not publish)

set -euo pipefail

BEFORE="${1:-}"
AFTER="${2:-}"

# Git's well-known empty tree hash. Used when BEFORE is the all-zero SHA
# GitHub sends on a branch's very first push (nothing to diff against).
EMPTY_TREE_SHA="4b825dc642cb6eb9a060e54bf8d69288fbee4904"

if [[ -z "$BEFORE" || "$BEFORE" == "0000000000000000000000000000000000000000" ]]; then
  BEFORE="$EMPTY_TREE_SHA"
fi

mapfile -t CHANGED_DIRS < <(
  git diff --name-only "$BEFORE" "$AFTER" -- charts/ \
    | awk -F/ 'NF>=2 {print $1"/"$2}' \
    | sort -u
)

MATRIX="[]"
TOUCHED_WITHOUT_BUMP=0
NEW_OR_BUMPED=0

if [[ "${#CHANGED_DIRS[@]}" -eq 0 ]]; then
  echo "No changes under charts/ detected. Nothing to publish."
else
  for dir in "${CHANGED_DIRS[@]}"; do
    [[ -z "$dir" ]] && continue

    chart_name="$(basename "$dir")"
    chart_yaml="${dir}/Chart.yaml"

    if [[ ! -f "$chart_yaml" ]]; then
      echo "::notice::Skipping '${chart_name}' — Chart.yaml not found at HEAD (chart likely deleted)."
      continue
    fi

    yaml_name="$(yq eval '.name' "$chart_yaml")"
    new_version="$(yq eval '.version' "$chart_yaml")"

    if [[ -z "$new_version" || "$new_version" == "null" ]]; then
      echo "::error::'${chart_name}' Chart.yaml is missing a version field."
      exit 1
    fi

    if [[ -n "$yaml_name" && "$yaml_name" != "null" && "$yaml_name" != "$chart_name" ]]; then
      echo "::warning::Directory '${chart_name}' does not match Chart.yaml name '${yaml_name}'. Using Chart.yaml name for the OCI artifact."
      chart_name="$yaml_name"
    fi

    old_version="$(git show "${BEFORE}:${chart_yaml}" 2>/dev/null | yq eval '.version' - 2>/dev/null || true)"

    if [[ -z "$old_version" || "$old_version" == "null" ]]; then
      echo "::notice::'${chart_name}' is a new chart (version ${new_version}) — will publish."
      NEW_OR_BUMPED=1
      MATRIX="$(jq -c --arg name "$chart_name" --arg path "$dir" --arg version "$new_version" \
        '. + [{"name": $name, "path": $path, "version": $version}]' <<<"$MATRIX")"
    elif [[ "$new_version" != "$old_version" ]]; then
      echo "::notice::'${chart_name}' version bumped (${old_version} -> ${new_version}) — will publish."
      NEW_OR_BUMPED=1
      MATRIX="$(jq -c --arg name "$chart_name" --arg path "$dir" --arg version "$new_version" \
        '. + [{"name": $name, "path": $path, "version": $version}]' <<<"$MATRIX")"
    else
      echo "::warning::Skipping '${chart_name}' — files changed but version was not bumped (still ${new_version})."
      TOUCHED_WITHOUT_BUMP=1
    fi
  done
fi

echo "Resulting matrix: ${MATRIX}"
echo "matrix=${MATRIX}" >> "$GITHUB_OUTPUT"

# Version-unchanged charts are skipped. If *every* touched chart skipped the
# bump, fail so a publish does not silently no-op after a charts/ change.
if [[ "$NEW_OR_BUMPED" -eq 0 && "$TOUCHED_WITHOUT_BUMP" -eq 1 ]]; then
  echo "::error::charts/ changed but no Chart.yaml version was bumped. Refusing to publish."
  exit 1
fi
