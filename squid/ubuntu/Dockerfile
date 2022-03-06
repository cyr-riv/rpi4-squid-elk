FROM ubuntu:latest
LABEL maintainer="cyrille.riviere.pro@gmail.com"

RUN groupadd squid \
&& useradd -g squid squid

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install squid
RUN apt-get -y install bind9-utils

#COPY conf/squid.conf /etc/squid
COPY bin/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
EXPOSE 1025/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]