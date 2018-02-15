# OpenShift and KubeVirt Multinode Demo

## Deploying OpenShift with Vagrant

This will create an OpenShift cluster with one manster and one node via
Vagrant:

```bash
make cluster-up
make cluster-openshift
```

The deployment can take pretty long. Also you will not see much output from the
openshift installer while it is running. To see what is going on in the installer run

```bash
vagrant ssh master -c "tailf /ansible.log"
```

Once the deployment is done, you can directly talk to the master via `./oc.sh`:

```bash
$ ./oc.sh get nodes
NAME      STATUS    ROLES     AGE       VERSION
master    Ready     master    3h        v1.9.1+a0ce1bc657
node      Ready     <none>    3h        v1.9.1+a0ce1bc657
```

To deploy `storage` run

```
make cluster-storage
```

Once it is done, you can see the storage deployed:

```bash
$ ./oc.sh get pods -n kube-system
NAME          READY     STATUS    RESTARTS   AGE
ceph-demo-0   7/7       Running   2          52m
```

## Deploying OpenShift on arbitrary nodes

First create an inventory:

```
[common]
node0 ansible_host=192.168.200.2 ansible_user=root
node1 ansible_host=192.168.200.3 ansible_user=root

[master]
master ansible_host=192.168.200.4 ansible_user=root

[storage]
master ansible_host=192.168.200.4 ansible_user=root
```

Save it in `myinventory`. Then run

```bask
ansible-playbook -i myinventory openshift.yaml
ansible-playbook -i myinventory storage.yaml
``
