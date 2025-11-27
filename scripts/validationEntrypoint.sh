#!/usr/bin/env bash

TAG="${SCALE_VALIDATION_BRANCH:-release}"

function exit_help() {
    >&2 echo "Usage: $0 <gpu arch> <test> [skip_n] [stop_after_n]"
    >&2 echo "See https://github.com/spectral-compute/scale-validation for supported tests"
    exit 1
}

if (( $# < 2 )); then
    exit_help
fi

GPU_ARCH="$1"
TEST="$2"
SKIP_N="${3:-}"
STOP_AFTER_N="${4:-}"

if ! which git >/dev/null; then
    if which apt-get >/dev/null; then
        apt-get update && apt-get install -y git
    else
        dnf install -y git
    fi
fi

git clone -b $TAG https://github.com/spectral-compute/scale-validation /scale-validation

mkdir -p /workdir

/scale-validation/test.sh /workdir /opt/scale $@
