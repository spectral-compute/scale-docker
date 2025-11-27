# devel - full scale toolkit
FROM docker.io/rockylinux/rockylinux:9.6 AS devel

LABEL maintainer="Spectral Compute <hello@spectralcompute.co.uk>"

RUN dnf install -y git which patch gcc clang elfutils-libelf-devel
RUN dnf install -y https://pkgs.scale-lang.com/rpm/el9/main/scale-repos.rpm

ARG SCALE_VERSION
RUN SCALE_LICENSE_ACCEPT=1 dnf install -y scale-$SCALE_VERSION

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
