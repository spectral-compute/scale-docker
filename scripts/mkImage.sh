#!/usr/bin/env bash
# Build one of the supported images
set -ETeuo pipefail
. "$(dirname "$0")/supported.sh"

function exit_help() {
    >&2 echo "Usage: $0 <cuda version> <distro> <target>"
    >&2 echo "See $(dirname "$0")/supported.sh for supported cuda versions, distros, and targets"
    exit 1
}

if (( $# < 3 )); then
    exit_help
fi

CUDA_VERSION="$1"
DISTRO="$2"
TARGET="$3"

contains() {
    [[ "$1" =~ (^|[[:space:]])$2($|[[:space:]]) ]] && echo 1 || echo 0
}

if [[ `contains "$SUPPORTED_CUDA_VERSIONS" $CUDA_VERSION` != "1" ]]; then
    >&2 echo "Unsupported cuda version: $CUDA_VERSION"
    exit_help
fi

if [[ `contains "$SUPPORTED_DISTROS" $DISTRO` != "1" ]]; then
    >&2 echo "Unsupported distro: $DISTRO"
    exit_help
fi

if [[ `contains "$SUPPORTED_TARGETS" $TARGET` != "1" ]]; then
    >&2 echo "Unsupported target: $TARGET"
    exit_help
fi

DOCKER_TAG_1="$CUDA_VERSION-$TARGET-$DISTRO"
DOCKER_TAG_2="$CUDA_VERSION-$TARGET-$DISTRO-$SCALE_VERSION"

ARGS=(
    -f "$(dirname "$0")/../images/${DISTRO}.Dockerfile"
    --build-arg CUDA_VERSION=$CUDA_VERSION
    --build-arg SCALE_VERSION=$SCALE_VERSION
    -t "$DOCKER_REPO:$DOCKER_TAG_1"
    -t "$DOCKER_REGISTRY/$DOCKER_REPO:$DOCKER_TAG_1"
    -t "$DOCKER_REPO:$DOCKER_TAG_2"
    -t "$DOCKER_REGISTRY/$DOCKER_REPO:$DOCKER_TAG_2"
    --target "${TARGET}"
)

if [ "$CUDA_VERSION" == "13.0.2" ] && [ "$DISTRO" == "ubuntu24.04" ] && [ "$TARGET" == "devel" ]; then
    ARGS+=(-t "$DOCKER_REPO:latest" -t "$DOCKER_REGISTRY/$DOCKER_REPO:latest")
fi

docker build \
    ${ARGS[@]} \
    "$(dirname "$0")/.."
