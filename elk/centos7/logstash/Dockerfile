FROM centos:centos7
# Update latest packges
RUN for iter in {1..10}; do yum update --setopt=tsflags=nodocs -y && \
    yum install --setopt=tsflags=nodocs -y tar nc zip unzip && \
    yum clean all && exit_code=0 && break || exit_code=\$? && echo "yum error: retry \$iter in 10s" && sleep 10; done; \
    (exit 0)
# Installing and setting Java
RUN cd /opt && curl --retry 8 -s -L -O https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.5%2B10/OpenJDK11U-jdk_aarch64_linux_11.0.5_10.tar.gz && cd -
RUN mkdir /opt/jdk-11.0.5 && chmod 0775 /opt/jdk-11.0.5 && tar zxf /opt/OpenJDK11U-jdk_aarch64_linux_11.0.5_10.tar.gz -C /opt/jdk-11.0.5 --strip-components=1 
RUN alternatives --install /usr/bin/java java /opt/jdk-11.0.5/bin/java 1 && \
    alternatives --display java
ENV JAVA_HOME /opt/jdk-11.0.5

# Setting the environment
ENV PATH /usr/share/logstash:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-11.0.5/bin:\$PATH
RUN groupadd -g 1000 logstash && \
    adduser -u 1000 -g 1000 -d /usr/share/logstash logstash
WORKDIR /usr/share/logstash
RUN chown -R 1000:0 /opt/jdk-11.0.5
RUN java -version


# Downloading and Installing Logstash (TAR)
RUN cd /opt && curl --retry 8 -s -L -O https://artifacts.elastic.co/downloads/logstash/logstash-oss-7.5.1.tar.gz && cd -
RUN tar zxf /opt/logstash-oss-7.5.1.tar.gz --strip-components=1

# Configuring Logstash
RUN mkdir -p config data fix
RUN chmod 0775 config data fix
COPY config/logstash.conf config/logstash.yml config/log4j2.properties config/
RUN chmod 0660 config/logstash.conf config/logstash.yml config/log4j2.properties
RUN chmod 0775 /usr/share/logstash && \
    chgrp 0 /usr/share/logstash
# Replace OpenJDK's built-in CA certificate keystore with the one from the OS
# vendor. The latter is superior in several ways.
# REF: https://github.com/elastic/logstash-docker/issues/171
RUN ln -sf /etc/pki/ca-trust/extracted/java/cacerts /opt/jdk-11.0.5/lib/security/cacerts
COPY --chown=1000:0 bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENV ELASTIC_CONTAINER true
RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh
EXPOSE 5044/tcp
EXPOSE 9600/tcp
EXPOSE 1025/tcp

# FIX Logstash issue 10755
# see: https://github.com/elastic/logstash/issues/10755
COPY --chown=1000:0 fix/fix-issue-10755.sh fix
RUN chgrp 0 /usr/share/logstash/fix/fix-issue-10755.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/share/logstash/fix/fix-issue-10755.sh
RUN /usr/share/logstash/fix/fix-issue-10755.sh

LABEL maintainer="cyrille.riviere.pro@gmail.com" \ 
  org.opencontainers.image.created="2020-01-29" \
  org.opencontainers.image.documentation="https://www.elastic.co/guide/en/logstash/reference/index.html" \
  org.opencontainers.image.licenses="Apache-2.0-License" \
  org.opencontainers.image.source="https://github.com/elastic/logstash" \
  org.opencontainers.image.title="Elasticsearch" \
  org.opencontainers.image.url="https://www.elastic.co/products/logstash" \
  org.opencontainers.image.vendor="Elastic" \
  org.opencontainers.image.version="7.5.1"
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]