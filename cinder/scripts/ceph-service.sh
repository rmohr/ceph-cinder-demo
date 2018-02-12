#!/bin/bash

set -e

yum -y install python-rbd python-rados iproute

if [[ -z "$MON_IP" ]]; then
  MON_IP=$(ip -o -4 a | tr -s ' ' | grep -v -e ' lo[0-9:]*.*$' | cut -d' ' -f 4  | head -1 | sed "s#/.*##")
  echo "Selected \"${MON_IP}\" as the IP address of the monitor"
fi

sed -e "s/{{ MON_IP }}/${MON_IP}/g" /etc/cinder/ceph.conf.in > /etc/cinder/ceph.conf

while [ ! -f /etc/ceph/ceph.conf ]
do
  sleep 2
done

while [ ! -f /etc/ceph/ceph.client.admin.keyring ]
do
  sleep 2
done

cinder-volume -d
