#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$1" == "console" ] || [ "$1" == "vnc" ]; then
  ${DIR}/.virtctl "$@" --kubeconfig=${DIR}/.kubeconfig --server https://{{ ansible_host }}:8443
else
  ${DIR}/.oc --config ${DIR}/.kubeconfig --server https://{{ ansible_host }}:8443 "$@"
fi

