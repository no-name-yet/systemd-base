#!/bin/bash
# run_args.sh - Run command from a given file
#
(
    # Run in a subshell so -e only applies to the commands in parantheses
    set -e
    CMD_FILE="${1:?Args file not passed to run_args.sh}"
    if ! [[ -r "$CMD_FILE" ]]; then
        echo "run_args.sh: Args file: '$CMD_FILE' not found"
    fi
    mapfile -t CMD < "$CMD_FILE"
    # remove the file since we don't need it anymore
    rm -f "$CMD_FILE" || :
    # Finally run the command
    "${CMD[@]}"
)
# Since this script is not running with -e the command below will always run
systemctl exit $?
# Exit with 0 so systemd doesn't think the service had failed
exit 0
