# Introduction

`Dockerfiles` to create the [Docker](https://www.docker.com/) containers images for the [Open Source ELK stack](https://www.elastic.co/).

**Elasticsearch** is a search engine based on the Lucene library. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents.

**Logstash** is a tool for managing events and logs. When used generically, the term encompasses a larger system of log collection, processing, storage and searching activities.

**Kibana** is an open source data visualization dashboard for Elasticsearch. It provides visualization capabilities on top of the content indexed on an Elasticsearch cluster. Users can create bar, line and scatter plots, or pie charts and maps on top of large volumes of data.

OS: CentOS7
Architecture: ARM64 (aarch64)

# Getting started

## Installation

```bash
docker pull cyrriv/elasticsearch-oss:7.5.1
docker pull cyrriv/logstash-oss:7.5.1
docker pull cyrriv/kibana-oss:7.5.1
```

## Quickstart

Start Elasticsearch OSS using:

```bash
sudo docker run -d \
    -p 9200:9200 \
    -p 9300:9300 \
    --name elasticsearch-oss \
    -v /home/ubuntu/elk/data/elasticsearch:/usr/share/elasticsearch/data:rw \
    -w /usr/share/elasticsearch/data \
    cyrriv/elasticsearch-oss:7.5.1
```

Configure the index mapping before starting logstash

```bash
curl -XPUT http://127.0.0.1:9200/squid-access \
    -H'Content-Type: application/json' \
    -d "$(cat ~/elk/elasticsearch/squid-access-elasticsearch-mapping.json)"
```

Start Logstash OSS using:

```bash
sudo docker run -d \
    --link elasticsearch-oss:elasticsearch \
    -p 1025:1025 \
    --name logstash-oss \
    cyrriv/logstash-oss:7.5.1
```

Start Kibana OSS using:

```bash
sudo docker run -d \
    --link elasticsearch-oss:elasticsearch \
    -p 5601:5601 \
    --name kibana-oss \
    cyrriv/kibana-oss:7.5.1
```
Connect to Kibana URL: http://<YOUR_HOST>:5601