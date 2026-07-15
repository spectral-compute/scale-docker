#!/usr/bin/env bash
# Compute tag strings for one app-hub project+gfx build. Meant to be sourced (not executed),
# from the scale-docker repo root, since it relies on scripts/supported.sh's own relative path.
# Usage: . scripts/apphub-tags.sh <project> <gfx> [destination]
# Sets INTERNAL_TAG, TEST_TAG always; PUBLIC_TAGS (space-separated) if destination given.
# Requires scale-validation/versions.txt to exist relative to cwd.
. "scripts/supported.sh" # for DOCKER_REGISTRY, SCALE_VERSION

PROJECT="$1"
GFX="$2"
DESTINATION="${3:-}"

VERSIONS_FILE="scale-validation/versions.txt"
[ -f "$VERSIONS_FILE" ] || { >&2 echo "Not found: $VERSIONS_FILE (expected scale-validation checked out relative to cwd)"; exit 1; }

PROJECT_VER="$(awk -v p="$PROJECT" '$1 == p { print $2; exit }' "$VERSIONS_FILE")"
[ -n "$PROJECT_VER" ] || { >&2 echo "Unknown project (not in $VERSIONS_FILE): $PROJECT"; exit 1; }

INTERNAL_TAG="$DOCKER_REGISTRY/spectral-compute/$PROJECT:$GFX-internal"
TEST_TAG="$DOCKER_REGISTRY/spectral-compute/$PROJECT:$GFX-test"

PUBLIC_TAGS=""
if [ -n "$DESTINATION" ]; then
    case "$DESTINATION" in
        quay)
            REPO="quay.io/spectral-compute/$PROJECT" # everywhere else
            ;;
        docker)
            REPO="docker.io/spectralcompute/$PROJECT" # docker.io: hyphen dropped, matches supported.sh's swap
            ;;
        *)
            >&2 echo "Unknown destination: $DESTINATION"
            exit 1
            ;;
    esac
    PUBLIC_TAGS="$REPO:$PROJECT_VER-$SCALE_VERSION-$GFX $REPO:latest-latest-$GFX $REPO:$GFX"
fi
