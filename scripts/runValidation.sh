#!/usr/bin/env bash
set -ETeuo pipefail

IMAGE="$1"
shift

CONTAINER_COMMAND=docker
if which docker >/dev/null; then
    CONTAINER_COMMAND=docker
elif which podman >/dev/null; then
    CONTAINER_COMMAND=podman
else
    echo "Couldn't detect command for running containers - install docker or podman"
fi

SCALE_VALIDATION_BRANCH="${SCALE_VALIDATION_BRANCH:-}"

$CONTAINER_COMMAND run -it --rm -e "SCALE_VALIDATION_BRANCH=$SCALE_VALIDATION_BRANCH" -v "$(dirname "$0")/validationEntrypoint.sh:/validationEntrypoint.sh" "$IMAGE" /validationEntrypoint.sh "$@"
