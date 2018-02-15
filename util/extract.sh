#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OPTIONS=$(vagrant ssh-config master | grep -v '^Host ' | awk -v ORS=' ' 'NF{print "-o " $1 "=" $2}')

scp $OPTIONS master:/usr/local/bin/oc ${DIR}/../.oc
chmod u+x ${DIR}/../.oc
vagrant ssh master -c "sudo cat /etc/origin/master/openshift-master.kubeconfig" >${DIR}/..//.kubeconfig
