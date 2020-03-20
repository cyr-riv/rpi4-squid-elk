FROM centos:centos7
# Update latest packges
RUN for iter in {1..10}; do yum update --setopt=tsflags=nodocs -y && \
    yum install --setopt=tsflags=nodocs -y tar nc zip unzip && \
    yum clean all && exit_code=0 && break || exit_code=\$? && echo "yum error: retry \$iter in 10s" && sleep 10; done; \
    (exit 0)

# Setting the environment
ENV PATH /usr/share/kibana:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\$PATH
RUN groupadd -g 1000 kibana && \
    adduser -u 1000 -g 1000 -d /usr/share/kibana kibana
WORKDIR /usr/share/kibana


# Downloading and Installing Logstash (TAR)
RUN cd /opt && curl --retry 8 -s -L -O https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.5.1-linux-x86_64.tar.gz && cd -
RUN tar zxf /opt/kibana-oss-7.5.1-linux-x86_64.tar.gz --strip-components=1

# Configuring Logstash
RUN mkdir -p config
RUN chmod 0775 config
COPY config/kibana.yml config/
RUN chmod 0660 config/kibana.yml                    
RUN chmod 0775 /usr/share/kibana && \
    chgrp 0 /usr/share/kibana
COPY --chown=1000:0 bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENV ELASTIC_CONTAINER true
RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh
EXPOSE 5601/tcp

# replace amd64 nodejs with arm64
RUN rm -rf /usr/share/kibana/node/*
RUN cd /opt && curl --retry 8 -s -L -O https://nodejs.org/dist/v10.15.2/node-v10.15.2-linux-arm64.tar.gz && cd -
RUN tar xzf /opt/node-v10.15.2-linux-arm64.tar.gz -C /usr/share/kibana/node/ --strip-components=1
RUN chown -R 1000:0 /usr/share/kibana/node

LABEL maintainer="cyrille.riviere.pro@gmail.com" \ 
  org.opencontainers.image.created="2020-01-29" \
  org.opencontainers.image.documentation="https://www.elastic.co/guide/en/kibana/reference/index.html" \
  org.opencontainers.image.licenses="Apache-2.0-License" \
  org.opencontainers.image.source="https://github.com/elastic/kibana" \
  org.opencontainers.image.title="Elasticsearch" \
  org.opencontainers.image.url="https://www.elastic.co/products/kibana" \
  org.opencontainers.image.vendor="Elastic" \
  org.opencontainers.image.version="7.5.1"
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]