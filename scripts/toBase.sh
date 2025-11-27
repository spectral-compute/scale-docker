#!/usr/bin/env bash
# Transform the installed SCALE package to have what we want in the base package
set -e
TO_REMOVE=(
    /opt/rocm-scale/include
    /opt/rocm-scale/lib/cmake
    /opt/rocm-scale/lib/pkgconfig
    /opt/rocm-scale/share/doc
    /opt/scale/include
    /opt/scale/cccl
    /opt/scale/lib
    /opt/scale/llvm/share/man
)
rm -rf ${TO_REMOVE[@]}
