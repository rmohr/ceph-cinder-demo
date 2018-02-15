#!/bin/bash

master_ip=$1

bash /vagrant/cluster/setup_common.sh

ADVERTISED_MASTER_IP=$(sshpass -p vagrant ssh -oStrictHostKeyChecking=no vagrant@$master_ip hostname -I | cut -d " " -f1)
set +e

echo 'Trying to register myself...'
# Skipping preflight checks because of https://github.com/kubernetes/kubeadm/issues/6
kubeadm join --token abcdef.1234567890123456 $ADVERTISED_MASTER_IP:6443 --ignore-preflight-errors=all --discovery-token-unsafe-skip-ca-verification=true
while [ $? -ne 0 ]; do
    sleep 30
    echo 'Trying to register myself...'
    # Skipping preflight checks because of https://github.com/kubernetes/kubeadm/issues/6
    kubeadm join --token abcdef.1234567890123456 $ADVERTISED_MASTER_IP:6443 --ignore-preflight-errors=all --discovery-token-unsafe-skip-ca-verification=true
done

echo -e "\033[0;32m Deployment was successful!\033[0m"
