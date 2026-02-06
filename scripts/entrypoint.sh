#!/usr/bin/env bash
set -e

case "${SCALE_LICENSE_PRINT:-0}" in
    [Yy]|[Yy]es|1)
        cat /opt/scale/LICENSE.txt
        ;;
    *)
        ;;
esac

case "${SCALE_LICENSE_ACCEPT:-0}" in
    [Yy]|[Yy]es|1)
        ;;
    *)
    cat <<EOF

    SCALE license agreement
    ========================

    In order to use this container image, you must accept the SCALE software license, a copy of which can be found at:

    * https://docs.scale-lang.com/stable/licensing/
    * In this container image, at /opt/scale/LICENSE.txt

    To indicate you've read and accepted this, please set the SCALE_LICENSE_ACCEPT=1 in this container.
    To print out the license text in full, set SCALE_LICENSE_PRINT=1

EOF
    exit 1
esac

echo "EULA accepted via environment variable (SCALE_LICENSE_ACCEPT=${SCALE_LICENSE_ACCEPT})."
if [[ $# -eq 0 ]]; then
    exec "/bin/bash"
else
    exec "$@"
fi
