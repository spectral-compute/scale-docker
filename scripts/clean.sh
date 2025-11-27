#!/usr/bin/env bash
# Cleanup leftover/unused files that we don't want to keep in our docker files
# Mostly package list caches, etc.
set -e

TO_REMOVE=(
    /var/lib/apt/lists /var/cache/* /var/log/* /scale-repos.*
    # Because we currently have a hard dependency on amdgpu-dkms,
    # we also end up installing that and a bunch of its build dependencies
    # This isn't ideal, but for now just nuke it manually.
   /boot  /etc/dkms /etc/fonts /usr/src /var/lib/dkms
)
rm -rf ${TO_REMOVE[@]}
