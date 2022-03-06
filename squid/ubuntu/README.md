# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Squid proxy server](http://www.squid-cache.org/).

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator.

OS: Ubuntu
Architecture: ARM64 (aarch64)

# Getting started

## Installation

```bash
docker pull cyrriv/squid:4.10
```

## Quickstart

Start Squid using:

```bash
sudo docker run --name squid -d \
    -p 3128:3128 \
    -v /home/ubuntu/squid/ubuntu/conf/squid.conf:/etc/squid/squid.conf \
    cyrriv/squid:4.10
```