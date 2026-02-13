#!/usr/bin/env bash
DOCKER_REGISTRY="${DOCKER_REGISTRY:-quay.io}"
if [ "$DOCKER_REGISTRY" == "docker.io" ]; then
    DOCKER_REPO=spectralcompute/scale # docker.io
    DOCKER_REPO2=spectral-compute/scale # everywhere else
else
    DOCKER_REPO=spectral-compute/scale # everywhere else
    DOCKER_REPO2=spectralcompute/scale # docker.io
fi

SUPPORTED_CUDA_VERSIONS="13.0.2 12.1.0 11.8.0 11.4.3"
SUPPORTED_DISTROS="ubuntu22.04 ubuntu24.04 rocky9"
SUPPORTED_TARGETS="base runtime devel"

SCALE_VERSION=1.5.1
