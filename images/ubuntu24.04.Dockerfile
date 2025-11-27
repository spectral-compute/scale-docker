# devel - full scale toolkit
FROM docker.io/ubuntu:24.04 AS devel

LABEL maintainer="Spectral Compute <hello@spectralcompute.co.uk>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget git clang gcc make pkg-config cmake libelf-dev

RUN wget https://pkgs.scale-lang.com/deb/dists/noble/main/binary-all/scale-repos.deb && \
    apt-get install -y ./scale-repos.deb

ARG SCALE_VERSION
RUN apt-get update && \
    SCALE_LICENSE_ACCEPT=1 apt-get install --no-install-recommends -y scale=$SCALE_VERSION

ARG CUDA_VERSION
ENV SCALE_CUDA_VERSION=$CUDA_VERSION

RUN --mount=type=bind,src=scripts/clean.sh,target=/clean.sh /clean.sh

ADD scripts/entrypoint.sh /entrypoint
ENTRYPOINT /entrypoint

# runtime - required bits for runtime, plus math libraries and NCCL
FROM devel AS runtime

RUN --mount=type=bind,src=scripts/toRuntime.sh,target=/toRuntime.sh /toRuntime.sh

# base - only the required runtime bits
FROM devel AS base

RUN --mount=type=bind,src=scripts/toBase.sh,target=/toBase.sh /toBase.sh
