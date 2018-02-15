#!/bin/bash

set -e

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


# Create the pool
ceph osd pool create images 64
# Import the cinder user.  This gives us a known key so we can use it also in
# a kubernetes secret.
ceph auth import -i /etc/cinder/ceph.client.cinder.keyring.in
ceph auth caps client.cinder mon 'allow r' osd 'allow class-read object_prefix rdb_children, allow rwx pool=images'
cp /etc/cinder/ceph.client.cinder.keyring.in /etc/ceph/ceph.client.cinder.keyring


cinder-volume -d
