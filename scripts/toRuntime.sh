#!/usr/bin/env bash
# Transform the installed SCALE package to have what we want in the runtime package
set -e
TO_REMOVE=(
    /opt/rocm-scale/lib/librocblas*
    /opt/rocm-scale/lib/rocblas
    /opt/rocm-scale/lib/rocprim
    /opt/rocm-scale/lib/librocfft*
    /opt/rocm-scale/lib/rocfft
    /opt/rocm-scale/lib/librocsolver*
    /opt/rocm-scale/lib/rocsolver
    /opt/rocm-scale/lib/librocsparse*
    /opt/rocm-scale/lib/librocrand*
    /opt/rocm-scale/lib/rocrand
    /opt/rocm-scale/share/doc

    /opt/scale/lib/libcudnn*
    /opt/scale/lib/libcusparse*
    /opt/scale/lib/libcusolver*
    /opt/scale/lib/libcurand*
    /opt/scale/lib/libcublas*
    /opt/scale/lib/libcufft*
)
rm -rf ${TO_REMOVE[@]}
