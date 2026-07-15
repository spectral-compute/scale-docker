# Nightly variant of ../ubuntu24.04.Dockerfile: installs a locally-provided SCALE .deb
# (pulled from the artefacts-store nightly build, see build-nightly-base.yml) instead of
# a versioned package from the apt repo. Build context must contain exactly one file at
# nightly-deb/scale-nightly.deb.

# devel - full scale toolkit
FROM docker.io/ubuntu:24.04 AS devel

LABEL maintainer="Spectral Compute <hello@spectralcompute.co.uk>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget git clang gcc make pkg-config cmake libelf-dev

COPY nightly-deb/scale-nightly.deb /tmp/scale-nightly.deb
RUN SCALE_LICENSE_ACCEPT=1 apt-get install --no-install-recommends -y /tmp/scale-nightly.deb && \
    rm /tmp/scale-nightly.deb

ARG CUDA_VERSION
ENV SCALE_CUDA_VERSION=$CUDA_VERSION

RUN --mount=type=bind,src=scripts/clean.sh,target=/clean.sh /clean.sh

ADD scripts/entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]

# runtime - required bits for runtime, plus math libraries and NCCL
FROM devel AS runtime

RUN --mount=type=bind,src=scripts/toRuntime.sh,target=/toRuntime.sh /toRuntime.sh

# base - only the required runtime bits
FROM devel AS base

RUN --mount=type=bind,src=scripts/toBase.sh,target=/toBase.sh /toBase.sh
