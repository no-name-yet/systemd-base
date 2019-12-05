FROM fedora:31

ENV container docker
VOLUME ["/sys/fs/cgroup"]

RUN ( \
    cd /lib/systemd/system/sysinit.target.wants/; \
    for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done \
    ); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    touch /etc/sysconfig/network

COPY sbin/ /sbin/
COPY etc/ /etc/

ENV ARGS_EXPORT_PATH=/etc/ci-container.args
# A list of variables to be made available in the environment the given command
# line args run in
ENV ARGS_ENV_INCLUDE="ARGS_EXPORT_PATH"

ENTRYPOINT ["/sbin/entrypoint.sh"]
