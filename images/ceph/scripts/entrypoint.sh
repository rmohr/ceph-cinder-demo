#!/bin/bash

set -e

if [[ -z "$MON_IP" ]]; then
  MON_IP=$(ip -o -4 a | tr -s ' ' | grep -v -e ' lo[0-9:]*.*$' | cut -d' ' -f 4  | head -1 | sed "s#/.*##")
  echo "Selected \"${MON_IP}\" as the IP address of the monitor"
fi
export MON_IP="$MON_IP"
export CEPH_PUBLIC_NETWORK="0.0.0.0/0"
/entrypoint.sh "$@"
