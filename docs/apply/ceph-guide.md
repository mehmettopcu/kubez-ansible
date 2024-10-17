# Ceph Guide

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- A functioning `ceph` cluster. Refer to the installation manual for [Ceph](https://docs.ceph.com/en/quincy/install/).

### Create `pool` and `client auth`

1. Log in to the `monitor` node of the `ceph` cluster to create a `pool` and `client auth` for `kubernetes` (let's assume the pool name is kube).

    ```bash
    ceph osd pool create kube 8 8
    ceph auth add client.kube mon 'allow r' osd 'allow rwx pool=kube'
    ```

2. Retrieve the `auth key` for the `ceph` cluster `admin` and the newly created pool `kube`.

    ```bash
    ceph auth get-key client.admin | base64 (record the output value as admin_key for use in subsequent steps)
    ceph auth get-key client.kube | base64 (record the output value as pool_key for use in subsequent steps)
    ```

### Enable `rbd_provisioner` Component

1. Log in to the deployment node and edit `/etc/kubez/globals.yml`.

    ```bash
    enable_rbd_provisioner: "yes"

    pool_name: kube
    monitors: monitor_ip:port (the default port is 6789)
    admin_key: admin_key
    pool_key: pool_key
    ```

2. Execute the following command to complete the `external ceph` integration.

    ```bash
    # multinode
    kubez-ansible -i multinode apply

    # all-in-one
    kubez-ansible apply
    ```

3. Verify after deployment.

    ```bash
    kubectl apply -f examples/test-rbd.yaml

    kubectl get pvc
    NAME       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    test-rbd   Bound    pvc-487cf629-24e8-4889-a977-dc8ac6c48d22   1Gi        RWO            rbd            25m

    rbd ls kube
    kubernetes-dynamic-pvc-d4a56035-4a94-11ea-aa72-d23b78a708e0
    ```
