#!/bin/bash -e
set -e

if [[ -z $1 ]] || [[ ${1:0:1} == '-' ]] ; then
  exec /usr/share/kibana/bin/kibana --allow-root
else
  exec "$@"
fi