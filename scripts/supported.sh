#!/usr/bin/env bash
DOCKER_REGISTRY="${DOCKER_REGISTRY:-quay.io}"
DOCKER_REPO=spectral-compute/scale

SUPPORTED_CUDA_VERSIONS="13.0.2 12.1.0 11.8.0 11.4.3"
SUPPORTED_DISTROS="ubuntu22.04 ubuntu24.04 rocky9"
SUPPORTED_TARGETS="base runtime devel"

SCALE_VERSION=1.5.0
