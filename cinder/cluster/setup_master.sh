#!/bin/bash

master_ip=$1
network_provider=$3

export KUBERNETES_MASTER=true
bash /vagrant/cluster/setup_common.sh

# Cockpit with kubernetes plugin
yum install -y cockpit cockpit-kubernetes
systemctl enable cockpit.socket && systemctl start cockpit.socket

# Create the master
kubeadm init --pod-network-cidr=10.244.0.0/16 --token abcdef.1234567890123456

# Tell kubectl which config to use
export KUBECONFIG=/etc/kubernetes/admin.conf

set +e

kubectl version
while [ $? -ne 0 ]; do
    sleep 60
    echo 'Waiting for Kubernetes cluster to become functional...'
    kubectl version
done

set -e

#if [ "$network_provider" == "weave" ]; then
#    kubever=$(kubectl version | base64 | tr -d '\n')
#    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
#else
#    kubectl create -f kube-$network_provider.yaml
#fi
# Workaround for https://github.com/weaveworks/weave/issues/3239
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml


# Allow scheduling pods on master
# Ignore retval because it might not be dedicated already
kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule- || :

mkdir -p /exports/share1

chmod 0755 /exports/share1
chown 36:36 /exports/share1

echo "/exports/share1  *(rw,anonuid=36,anongid=36,all_squash,sync,no_subtree_check)" >/etc/exports

systemctl enable nfs-server && systemctl start nfs-server

echo -e "\033[0;32m Deployment was successful!"
echo -e "Cockpit is accessible at https://$master_ip:9090."
echo -e "Credentials for Cockpit are 'root:vagrant'.\033[0m"
