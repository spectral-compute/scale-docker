# scale-docker

This repo contains the files we use to build SCALE docker/OCI images, for use in Docker, Kubernetes, or any other environment that can run OCI-compliant containers.

Each image installs SCALE to `/opt/scale`, as it would be when installing on a host. See [here](https://docs.scale-lang.com/stable/manual/how-to-use/) for how to use SCALE to build/run your programs.

## Using pre-built images

Pre-built images are hosted on quay.io, you can use the path `quay.io/spectral-compute/scale-lang`.

We try our best to imitate the tag layout of NVIDIA's CUDA docker images.
Tags are in the format `$CUDA_VERSION-$TARGET-$DISTRO[-$SCALE_VERSION]`, where:

  - Target is one of:
    - `devel` - which includes the full SCALE developer toolkit
    - `runtime` - which includes only the parts required for runtime, including maths libraries
    - `base` - which includes only the minimum runtime
  - Distro is one of:
    - `ubuntu22.04`, based off of `docker.io/ubuntu:22.04`
    - `ubuntu24.04`, based off of `docker.io/ubuntu:24.04`
    - `rocky9`, based off of `docker.io/rockylinux/rockylinux:9`
  - Cuda version is one of:
    - `13.0.2`
    - `12.1.0`
    - `11.8.0`
    - `11.4.3`
  - If SCALE_VERSION is not specified, default to latest

For convenience, the `latest` tag is equivalent to `13.0.2-devel-ubuntu24.04`.

```
# Example: Pull the image for building using the latest SCALE, imitating CUDA 13.0.2, on ubuntu22.04
docker pull quay.io/spectral-compute/scale-lang:13.0.2-devel-ubuntu22.04
```

## Building images

To build a particular tag:

```
# ./scripts/mkImage.sh <cuda version> <distro> <target>

# Example: CUDA 13, with developer tools, for ubuntu22.04
./scripts/mkImage.sh 13.0.2 ubuntu22.04 devel
```

Images are tagged both qualified and unqualified (ie `quay.io/spectral-compute/scale-lang` and `spectral-compute/scale-lang`). Optionally, you can set the `DOCKER_REPO` environment variable to change what docker registry the image is tagged under. No images are pushed.

## Running scale-validation with images

For convenience, `./scripts/runValidation.sh` will clone the [scale-validation repo](https://github.com/spectral-compute/scale-validation) and run a test of your choice. You can use this to test that your setup / custom image is running correctly.

```bash
# ./scripts/runValidation.sh <image> <gpu isa> <test>

# Example: gfx1100 on hashcat
./scripts/runValidation.sh spectral-compute/scale-lang:13.0.2-devel-ubuntu22.04 gfx1100 hashcat
```

Optionally, you can set the `SCALE_VALIDATION_BRANCH` environment variable to use a different branch/tag.

## Running images

In order to share the host's GPU with the container, you must mount the `/dev/kfd` and `/dev/dri` directories. Using the docker CLI, this is done by adding `--device /dev/kfd --device /dev/dri`. The `--gpus` flag is insufficient for AMD cards.
