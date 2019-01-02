FROM centos:7

ENV container docker
COPY sbin/export_environment.sh /sbin/export_environment
COPY systemd/* /etc/systemd/system/
RUN chmod +x /sbin/export_environment
RUN systemctl enable export-environment.service
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
VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
