#!/bin/bash

set -e

yum -y install python-rbd python-rados


while [ ! -f /etc/ceph/ceph.conf ]
do
  sleep 2
done

while [ ! -f /etc/ceph/ceph.client.admin.keyring ]
do
  sleep 2
done

cinder-volume -d
