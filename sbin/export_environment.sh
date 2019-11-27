#!/bin/bash -xe
#
# export_environment.sh - copy selected environment variables from pid 1
# and place in a well known location. It allows us to have systemd as the
# entry point of the container but still have the ability to pass environment
# variables through cli.
#

main() {
    local include

    eval "$(get_env_vars ENV_INCLUDE_LIST ENV_EXPORT_PATH)"
    [[ $ENV_INCLUDE_LIST ]] || return
    [[ $ENV_EXPORT_PATH ]] || return

    #shellcheck disable=SC2086
    get_env_vars $ENV_INCLUDE_LIST >> "$ENV_EXPORT_PATH"
    chmod 0644 "$ENV_EXPORT_PATH"
}

get_env_vars() {
    include=$(join "$@")
    /usr/bin/tr \\000 \\n < /proc/1/environ |
        sed -nre "/^($include)=/{s/ /\\\\ /;p}"
}

join() {
    local IFS="|"
    echo "$*"
}

main "$@"
