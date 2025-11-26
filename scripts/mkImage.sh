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

DOCKER_REGISTRY=docker.io
DOCKER_REPO=spectral-compute/scale-lang
DOCKER_TAG="$CUDA_VERSION-$TARGET-$DISTRO"

ARGS=(
    -f "$(dirname "$0")/../images/${DISTRO}.Dockerfile"
    -t "$DOCKER_REPO:$DOCKER_TAG"
    --build-arg CUDA_VERSION=$CUDA_VERSION
    -t "$DOCKER_REGISTRY/$DOCKER_REPO:$DOCKER_TAG"
    --target "${TARGET}"
)
docker build \
    ${ARGS[@]} \
    "$(dirname "$0")/.."
