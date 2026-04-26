#!/usr/bin/env bash
# bump.sh — update Formula/quish.rb to a new release tag.
#
# Usage:
#   ./bump.sh v0.5.3-beta.1            # bump and stage changes
#   ./bump.sh v0.5.3-beta.1 --commit   # bump, commit, and print push hint
#
# Fetches the GitHub-generated tarball for the given tag in dakka/quish,
# computes its sha256, and rewrites the url + sha256 lines in
# Formula/quish.rb. Idempotent - safe to run repeatedly.
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "usage: $0 <tag> [--commit]" >&2
    echo "  e.g. $0 v0.5.3-beta.1" >&2
    exit 1
fi

TAG="$1"
COMMIT=0
[[ "${2:-}" == "--commit" ]] && COMMIT=1

REPO="dakka/quish"
URL="https://github.com/${REPO}/archive/refs/tags/${TAG}.tar.gz"
FORMULA="Formula/quish.rb"

if [[ ! -f "$FORMULA" ]]; then
    echo "error: $FORMULA not found - run from the tap repo root" >&2
    exit 1
fi

echo "Fetching $URL ..."
SHA="$(curl -sL --fail "$URL" | shasum -a 256 | cut -d' ' -f1)"

if [[ -z "$SHA" || "$SHA" == "$(printf '' | shasum -a 256 | cut -d' ' -f1)" ]]; then
    echo "error: failed to fetch tarball or got empty sha256 (does the tag exist?)" >&2
    exit 1
fi

echo "Tag:    $TAG"
echo "URL:    $URL"
echo "SHA256: $SHA"

# Rewrite the url + sha256 lines. Use a portable sed (works on GNU and BSD).
tmp="$(mktemp)"
awk -v url="$URL" -v sha="$SHA" '
    /^  url / { print "  url \"" url "\""; next }
    /^  sha256 / { print "  sha256 \"" sha "\""; next }
    { print }
' "$FORMULA" > "$tmp"
mv "$tmp" "$FORMULA"

echo
echo "Updated $FORMULA:"
grep -E '^\s*(url|sha256)' "$FORMULA"

if (( COMMIT )); then
    git add "$FORMULA"
    git commit -m "quish $TAG"
    echo
    echo "Committed. Push with:"
    echo "  git push"
fi
