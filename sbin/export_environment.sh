#!/bin/bash -xe
#
# export_environment.sh - copy selected environment variables from pid 1
# and place in a well known location. It allows us to have systemd as the
# entry point of the container but still have the ability to pass environment
# variables through cli.
#

# An array of variables to be exported to $export_path
INCLUDE_LIST=($(cat /etc/export_list ||:))

main() {
    local export_path="${1:?}"
    local include

    [[ ${#INCLUDE_LIST[@]} -eq 0 ]] && return

    include=$(join "${INCLUDE_LIST[@]}")
    /usr/bin/tr \\000 \\n < /proc/1/environ |
        grep -E "^($include)=" >> "$export_path"
    chmod 0644 "$export_path"
}

join() {
    local IFS="|"
    echo "$*"
}

main "$@"
