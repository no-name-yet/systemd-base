#!/bin/bash -e
# Read command-line arguments and store them in a file to be used later
#
if [[ $# -gt 0 ]] && [[ $1 ]]; then
    # Podman seems to have an issue where `podman commit` cannot create images
    # without a CMD setting, and adding `--change='CMD []'` results in the
    # command being an array with a single string in it. Therefor we detect that
    # particular case above and treat it as if a command was not given
    echo "Got $# command-line arguments, enabling run-args service"
    printf '%s\n' "$@" > "$ARGS_EXPORT_PATH"
    # Update list of variables that systemd will pass to invoked process on the
    # fly. Unfortunately this dirty `sed` is the only way to do that
    #
    # We create the *.service file from in *.service.in file rather then making
    # the change to the file in-place, so that the change can be undone without
    # leaving overlayfs records behind
    #
    /usr/bin/sed -re "s/\\\$ARGS_ENV_INCLUDE/$ARGS_ENV_INCLUDE/" \
        /etc/systemd/system/run-args.service.in \
        > /etc/systemd/system/run-args.service \
    # Enable service to run the arguments
    systemctl enable run-args.service
fi

exec /usr/sbin/init
