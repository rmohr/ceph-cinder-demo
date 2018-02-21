# OpenShift and KubeVirt Multinode Demo

## Deploying OpenShift with Vagrant

This will create an OpenShift cluster with one manster and one node via
Vagrant:

### OpenShift

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

### Storage Provisioner

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

To test the installation, start a pod which requests storage from that
provisioner:

```bash
$ ./oc.sh create -f examples/storage-pod.yaml
$ /oc.sh get pvc
NAME       STATUS    VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS        AGE
demo-pvc   Bound     pvc-2d1a98e1-12ef-11e8-a1c4-525400cc240d   1Gi        RWO            standalone-cinder   24m
$ ./oc.sh get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS    CLAIM              STORAGECLASS        REASON    AGE
pvc-2d1a98e1-12ef-11e8-a1c4-525400cc240d   1Gi        RWO            Delete           Bound     default/demo-pvc   standalone-cinder             24m
```

### KubeVirt

To deploy `KubeVirt` run

```
make cluster-kubevirt
```

Once it is done, you can see all KubeVirt pods deployed:

```bash
$ ./oc.sh get pods -n kube-system
NAME                              READY     STATUS    RESTARTS   AGE
virt-controller-66d948c84-kmfxs   0/1       Running   0          17m
virt-controller-66d948c84-mmmnx   1/1       Running   0          17m
virt-handler-64sjz                1/1       Running   0          17m
virt-handler-ps8ds                1/1       Running   0          17m
```

To test the installation, start a vm with alpine:

```bash
$ ./oc.sh create -f examples/vm.yaml
$ sleep 300 # We need to pull a lot when the first vm starts on a node
$ ./oc.sh get vms -o yaml | grep phase
    phase: Running
```

To connect to a VM:

```bash
./oc.sh console demo-vm  # Serial console
./oc.sh vnc demo-vm      # VNC
```

To import and run a cirros vm:

```bash
$ ./oc.sh create -f examples/import-cirros.yaml
$ sleep 120  # The cirros disk image downloads into a PVC
$ ./oc.sh get pod disk-importer  # Repeat until pod is Completed
$ ./oc.sh create -f examples/vm-cirros-clone.yaml
$ ./oc.sh get vms -o yaml | grep phase
    phase: Running
```

## Deploying OpenShift on arbitrary nodes

First create an inventory:

```
[nodes]
node1 ansible_ssh_host=192.168.200.4 ansible_user=root
node2 ansible_ssh_host=192.168.200.3 ansible_user=root

[masters]
master ansible_ssh_host=192.168.200.2 ansible_user=root
```

Save it in `myinventory`. Then run

```bask
ansible-playbook -i myinventory openshift.yaml
ansible-playbook -i myinventory storage.yaml
ansible-playbook -i myinventory kubevirt.yaml
``
