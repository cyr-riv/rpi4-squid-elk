FROM centos:centos7
# Update latest packges
RUN for iter in {1..10}; do yum update --setopt=tsflags=nodocs -y && \
    yum install --setopt=tsflags=nodocs -y gzip shadow-utils tar nc zip unzip && \
    yum clean all && exit_code=0 && break || exit_code=\$? && echo "yum error: retry \$iter in 10s" && sleep 10; done; \
    (exit 0)
# Installing and setting Java
RUN cd /opt && curl --retry 8 -s -L -O https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.5%2B10/OpenJDK11U-jdk_aarch64_linux_11.0.5_10.tar.gz && cd -
RUN mkdir /opt/jdk-11.0.5 && chmod 0775 /opt/jdk-11.0.5 && tar zxf /opt/OpenJDK11U-jdk_aarch64_linux_11.0.5_10.tar.gz -C /opt/jdk-11.0.5 --strip-components=1 
RUN alternatives --install /usr/bin/java java /opt/jdk-11.0.5/bin/java 1 && \
    alternatives --display java
ENV JAVA_HOME /opt/jdk-11.0.5

# Setting the environment
ENV PATH /usr/share/elasticsearch:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/jdk-11.0.5/bin:\$PATH
RUN groupadd -g 1000 elasticsearch && \
    adduser -u 1000 -g 1000 -d /usr/share/elasticsearch elasticsearch
WORKDIR /usr/share/elasticsearch
RUN chown -R 1000:0 /opt/jdk-11.0.5
RUN java -version


# Downloading and Installing Elasticsearch (TAR)
RUN cd /opt && curl --retry 8 -s -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.5.1-no-jdk-linux-x86_64.tar.gz && cd -
RUN tar zxf /opt/elasticsearch-oss-7.5.1-no-jdk-linux-x86_64.tar.gz --strip-components=1
RUN grep ES_DISTRIBUTION_TYPE=tar /usr/share/elasticsearch/bin/elasticsearch-env \
    && sed -i -e 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' /usr/share/elasticsearch/bin/elasticsearch-env

# Configuring Elastisearch
RUN mkdir -p config data logs
RUN chmod 0775 config data logs
COPY config/elasticsearch.yml config/log4j2.properties config/
RUN chmod 0660 config/elasticsearch.yml config/log4j2.properties
RUN chmod 0775 /usr/share/elasticsearch && \
    chgrp 0 /usr/share/elasticsearch
# Replace OpenJDK's built-in CA certificate keystore with the one from the OS
# vendor. The latter is superior in several ways.
# REF: https://github.com/elastic/elasticsearch-docker/issues/171
RUN ln -sf /etc/pki/ca-trust/extracted/java/cacerts /opt/jdk-11.0.5/lib/security/cacerts
COPY --chown=1000:0 bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENV ELASTIC_CONTAINER true
RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh
EXPOSE 9200 9300
LABEL maintainer="cyrille.riviere.pro@gmail.com" \ 
  org.opencontainers.image.created="2020-01-29" \
  org.opencontainers.image.documentation="https://www.elastic.co/guide/en/elasticsearch/reference/index.html" \
  org.opencontainers.image.licenses="Apache-2.0-License" \
  org.opencontainers.image.source="https://github.com/elastic/elasticsearch" \
  org.opencontainers.image.title="Elasticsearch" \
  org.opencontainers.image.url="https://www.elastic.co/products/elasticsearch" \
  org.opencontainers.image.vendor="Elastic" \
  org.opencontainers.image.version="7.5.1"
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["eswrapper"]