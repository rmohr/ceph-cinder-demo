#!/bin/bash
#
# This file is part of the KubeVirt project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright 2017 Red Hat, Inc.
#

#set -ex

source hack/common.sh
source cluster/provider.sh
source hack/config.sh

echo "Cleaning up ..."
# Work around https://github.com/kubernetes/kubernetes/issues/33517
_kubectl delete pods -n kube-system ceph-demo-0 --force --grace-period 0 2>/dev/null || :
_kubectl delete -f demo.yaml
_kubectl delete clusterrolebinding add-on-cluster-admin
_kubectl delete clusterrolebinding add-on-default-admin

sleep 2

echo "Deploying ..."
_kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
_kubectl create clusterrolebinding add-on-default-admin --clusterrole=cluster-admin --serviceaccount=default:default
_kubectl create -f demo.yaml

echo "Done"
