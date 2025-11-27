#!/usr/bin/env bash
set -e

if [ "${SCALE_LICENSE_PRINT:-0}" == "1" ]; then
    cat /opt/scale/LICENSE.txt
fi

if [ "${SCALE_LICENSE_ACCEPT:-0}" != "1" ]; then
    cat <<EOF

    SCALE license aggreement
    ========================

    In order to use this container image, you must accept the SCALE software license, a copy of which can be found at:

    * https://docs.scale-lang.com/stable/licensing/
    * In this container image, at /opt/scale/LICENSE.txt

    To indicate you've read and accepted this, please set the SCALE_LICENSE_ACCEPT=1 in this container.
    To print out the license text in full, set SCALE_LICENSE_PRINT=1

EOF

    exit 1
fi

echo "EULA accepted via environment variable (SCALE_LICENSE_ACCEPT=1)."
if [[ $# -eq 0 ]]; then
    exec "/bin/bash"
else
    exec "$@"
fi
