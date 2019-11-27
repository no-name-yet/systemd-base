#!/bin/bash -e
# Read command-line arguments and store them in a file to be used later
#
printf '%s\n' "$@" > "$ARGS_EXPORT_PATH"

exec /usr/sbin/init
