# Harbor Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- StorageClass.

## Enable Harbor Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_harbor: "no"` and set it to `"yes"`.

    ```shell
    #################
    # Harbor Options
    #################
    enable_harbor: "yes"
    #harbor_name: harbor
    #harbor_namespace: "{{ kubez_namespace }}"
    # Configure the storage size to be used by Harbor
    harbor_storage_size: "18Gi"
    # Configure the password for the admin user
    harbor_admin_password: "Harbor12345"
    ```

3. Execute the installation command (choose based on your scenario).

    ```shell
    # Single node cluster scenario
    kubez-ansible apply

    # High availability cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Verify after deployment.

    ```shell
    # Harbor PVC allocation successful
    [root@pixiu kubez]# kubectl get pvc -n pixiu-system
    NAME                              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
    data-harbor-redis-0               Bound    pvc-f5237b46-5748-4ae3-ad8c-90bab1bb0534   15Gi       RWO            managed-nfs-storage   16d
    data-harbor-trivy-0               Bound    pvc-dd2e31d5-e36e-426c-b9c4-732fb24295bd   15Gi       RWO            managed-nfs-storage   16d
    data-mariadb-0                    Bound    pvc-f71527d1-bcd1-4a20-b6f4-6a6a3096bcf9   10Gi       RWO            managed-nfs-storage   17d
    database-data-harbor-database-0   Bound    pvc-f278bad4-e51c-429b-b845-b240afc220a2   15Gi       RWO            managed-nfs-storage   16d
    harbor-chartmuseum                Bound    pvc-6e4aa2d1-34ac-40e5-8b52-c5085271b503   19Gi       RWO            managed-nfs-storage   10d
    harbor-jobservice                 Bound    pvc-c9d30ec7-8bbb-470e-bdc0-018dceffa2cc   1Gi        RWO            managed-nfs-storage   10d
    harbor-jobservice-scandata        Bound    pvc-7e1b0a36-ff01-4fce-a43d-c6ce8de64eeb   1Gi        RWO            managed-nfs-storage   10d
    harbor-registry                   Bound    pvc-7d143c4c-c4ce-4846-bfc3-43b6f1333a51   19Gi       RWO            managed-nfs-storage   10d

    # All Harbor pods are running normally
    [root@pixiu kubez]# kubectl get pod -n pixiu-system
    NAME                                             READY   STATUS             RESTARTS           AGE
    harbor-chartmuseum-76ff89f9d4-nlljp              1/1     Running            0                  10d
    harbor-core-55787dc698-qfqhg                     1/1     Running            0                  10d
    harbor-database-0                                1/1     Running            0                  10d
    harbor-jobservice-c797dd585-rgbrs                1/1     Running            3 (10d ago)        10d
    harbor-nginx-fc68874d5-69zw2                     1/1     Running            0                  10d
    harbor-notary-server-5c97479877-8hm9z            1/1     Running            0                  10d
    harbor-notary-signer-7d56fd69c7-drc68            1/1     Running            0                  10d
    harbor-portal-b7d5d9558-988zr                    1/1     Running            0                  10d
    harbor-redis-0                                   1/1     Running            0                  10d
    harbor-registry-dc457dd49-9fpfh                  2/2     Running            0                  10d
    harbor-trivy-0                                   1/1     Running            0                  10d
    ```

5. Functionality verification
   TODO
