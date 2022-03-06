#!/bin/bash
set -e

create_log_dir() {
  sudo mkdir -p ${SQUID_LOG_DIR}
  sudo chmod -R 755 ${SQUID_LOG_DIR}
  sudo chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  sudo mkdir -p ${SQUID_CACHE_DIR}
  sudo chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

create_log_dir
create_cache_dir

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    sudo squid -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  exec sudo squid -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi