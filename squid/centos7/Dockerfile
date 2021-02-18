FROM centos:7
LABEL maintainer="cyrille.riviere.pro@gmail.com"

RUN groupadd squid \
&& useradd -g squid squid

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

RUN yum -y update
RUN yum -y install squid
RUN yum -y install bind-utils

#COPY conf/squid.conf /etc/squid
COPY bin/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
EXPOSE 1025/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]