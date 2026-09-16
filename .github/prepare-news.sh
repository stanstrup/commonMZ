#!/bin/bash
# prepare-news.sh - update DESCRIPTION version and NEWS.md before release
set -e

VERSION=${SEMANTIC_RELEASE_NEXT_RELEASE_VERSION:-$1}
RELEASE_NOTES=${SEMANTIC_RELEASE_NEXT_RELEASE_NOTES:-$2}

if [ -z "$VERSION" ]; then
  echo "ERROR: version not set"
  exit 1
fi

echo "Preparing release $VERSION..."

RELEASE_DATE=$(date +%Y-%m-%d)
COMMIT_SHA=$(git rev-parse --short HEAD)

# Strip top-level version header added by semantic-release
CLEANED_NOTES=$(echo "$RELEASE_NOTES" | sed -E '/^#{1,2} (\[)?[0-9]+\.[0-9]+\.[0-9]+/d')

# Prepend new entry to NEWS.md
if [ -f NEWS.md ]; then
  cp NEWS.md NEWS.md.bak
else
  touch NEWS.md.bak
fi

{
  echo "## Changes in v$VERSION (commit: $COMMIT_SHA)"
  echo ""
  echo "$CLEANED_NOTES"
  echo ""
  cat NEWS.md.bak
} > NEWS.md

rm NEWS.md.bak

# Update DESCRIPTION version
sed -i "s/^Version: .*/Version: $VERSION/" DESCRIPTION

# Configure git
git config user.name "github-actions[bot]" || true
git config user.email "github-actions[bot]@users.noreply.github.com" || true

# Remove any local semantic-release tags
for tag in $(git tag | grep "^semantic-release-" || true); do
  git tag -d "$tag" || true
done

git add NEWS.md DESCRIPTION

git commit -m "chore(release): $VERSION [skip ci]

$RELEASE_NOTES"

if [ -n "$GITHUB_TOKEN" ]; then
  git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
  git push --no-follow-tags
else
  echo "WARNING: GITHUB_TOKEN not set, skipping push"
fi

echo "Committed and pushed version $VERSION"
