# scale-docker

This repo contains the files we use to build SCALE docker/OCI images, for use in Docker, Kubernetes, or any other environment that can run OCI-compliant containers.

We try our best to imitate the tag layout of NVIDIA's CUDA docker images.

## Running scale-validation with images

For convenience, `./scripts/runValidation.sh` will clone the [scale-validation repo](https://github.com/spectral-compute/scale-validation) and run a test of your choice. You can use this to test that your setup / custom image is running correctly.

```bash
# ./scripts/runValidation.sh <image> <gpu isa> <test>

# Example: gfx1100 on hashcat
./scripts/runValidation.sh spectral-compute/scale-lang:13.0.2-devel-ubuntu22.04 gfx1100 hashcat
```

Optionally, you can set the `SCALE_VALIDATION_BRANCH` environment variable to use a different branch/tag.
