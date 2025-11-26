# devel - full scale toolkit
FROM ubuntu:22.04 AS devel

ARG CUDA_VERSION
ENV SCALE_CUDA_VERSION=$CUDA_VERSION

LABEL maintainer="Spectral Compute <hello@spectralcompute.co.uk>"

RUN apt-get update && apt-get install -y wget

RUN wget https://pkgs.scale-lang.com/deb/dists/jammy/main/binary-all/scale-repos.deb && \
    apt-get install -y ./scale-repos.deb

RUN apt-get update && \
    SCALE_LICENSE_ACCEPT=1 apt-get install -y scale

RUN --mount=type=bind,src=scripts/clean.sh,target=/clean.sh /clean.sh

# runtime - required bits for runtime, plus math libraries and NCCL
FROM devel AS runtime

RUN --mount=type=bind,src=scripts/toRuntime.sh,target=/toRuntime.sh /toRuntime.sh

# base - only the required runtime bits
FROM devel AS base

RUN --mount=type=bind,src=scripts/toBase.sh,target=/toBase.sh /toBase.sh
