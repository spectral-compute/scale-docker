#!/usr/bin/env bash
# Build all images we support
set -ETeuo pipefail
. "$(dirname "$0")/supported.sh"
for CUDA_VERSION in ${SUPPORTED_CUDA_VERSIONS[@]}; do
    echo "- $CUDA_VERSION"
    for DISTRO in ${SUPPORTED_DISTROS[@]}; do
        echo "-- $DISTRO"
        for TARGET in ${SUPPORTED_TARGETS[@]}; do
            echo "--- $TARGET"
            $(dirname "$0")/mkImage.sh "$CUDA_VERSION" "$DISTRO" "$TARGET"
        done
    done
done
