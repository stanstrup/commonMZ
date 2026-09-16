#!/bin/bash
# release.sh - create GitHub release and tag
set -e

VERSION=${SEMANTIC_RELEASE_NEXT_RELEASE_VERSION:-$1}

if [ -z "$VERSION" ]; then
  echo "ERROR: version not set"
  exit 1
fi

echo "Creating GitHub release for $VERSION..."

# Extract release notes for this version from NEWS.md
NEWS_CONTENT=$(awk '/## Changes in v'"$VERSION"'/,/## Changes in v[0-9]/ {
  if (/## Changes in v[0-9]/ && !/## Changes in v'"$VERSION"'/) exit;
  if (!/## Changes in v'"$VERSION"'/) print
}' NEWS.md)

if [ -z "$GITHUB_TOKEN" ]; then
  echo "ERROR: GITHUB_TOKEN not set"
  exit 1
fi

# Delete existing release/tag if present
if gh release view "$VERSION" &>/dev/null; then
  gh release delete "$VERSION" --yes --cleanup-tag
fi
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  git tag -d "$VERSION"
fi

gh release create "$VERSION" \
  --title "commonMZ v$VERSION" \
  --notes "$NEWS_CONTENT" \
  --latest

echo "GitHub release $VERSION created successfully"
