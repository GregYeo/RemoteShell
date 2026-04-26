#!/bin/bash

REMOTE_HOST="192.168.10.1"
REMOTE_DIR="/tmp"
CMD_FILE="/tmp/remote-action.sh"

# 1. Capture the command exactly as typed
REMOTE_COMMAND="$@"

if [ -z "$1" ]; then
    echo "Usage: remote <command>"
    exit 1
fi

cat <<EOF > /tmp/local-dispatch.sh
set -e
cd "$REMOTE_DIR"
$REMOTE_COMMAND
EOF

# Ship it and Rip it
# -q hides scp output, -t forces the color/TTY
scp -q /tmp/local-dispatch.sh ${REMOTE_HOST}:${CMD_FILE}
ssh -t ${REMOTE_HOST} "bash ${CMD_FILE}"