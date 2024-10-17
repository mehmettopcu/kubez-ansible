# MinIO Installation

## Prerequisites

- A properly functioning `kubernetes` environment. For installation manuals, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

### Enabling MinIO Components

1. Enable `minio` and configure parameters.

    ```shell
   # Uncomment `enable_minio: "no"` and set it to "yes" to enable MinIO
   #################
   # Minio Options
   #################
   enable_minio: "yes"
   #minio_namespace: "{{ kubez_namespace }}"

   # Uncomment and modify according to your actual situation
   #minio_storage_class: managed-nfs-storage
   #minio_storage_size: 500Gi
   # Recommended for production environment: 16Gi
   #minio_memory_size: 4Gi

   # applicable only for MinIO distributed mode
   # Define the number of replicas; recommended 16 for production
   #minio_replicas: 4
   # Define the user and password for logging into the web interface
   #minio_rootUser: minioadmin
   #minio_rootPassword: minioadmin
    ```

2. Execute the installation command (choose according to your situation).

   ```shell
   # Single node cluster scenario
   kubez-ansible apply

   # High availability cluster scenario
   kubez-ansible -i multinode apply
   ```

3. Validate after deployment.

   ```shell
   [root@VM-10-centos ~]# kubectl get pods -n pixiu-system | grep minio
   NAMESPACE       NAME                                  READY   STATUS    RESTARTS         AGE
   pixiu-system    minio-0                               1/1     Running     0              168m
   pixiu-system    minio-1                               1/1     Running     0              168m
   pixiu-system    minio-2                               1/1     Running     0              168m
   pixiu-system    minio-3                               1/1     Running     0              168m
   ```

4. (Optional) Modify the `svc` to verify web interface login access.

   ```shell
   [root@VM-10-centos ~]# kubectl get svc -A | grep minio
   minio               minio                            ClusterIP      10.43.185.7     <none>        9000/TCP                5d4h
   minio               minio-console                    ClusterIP      10.43.45.84     <none>        9001/TCP                5d4h
   minio               minio-svc                        ClusterIP      None            <none>        9000/TCP                5d4h
   [root@VM-10-centos ~]# kubectl edit svc -n pixiu-system minio-console
   Change `type: ClusterIP` to `type: NodePort`
   ```

   Then check the `svc` again.

   ```shell
   [root@VM-10-centos ~]# kubectl get svc -A | grep minio
   minio               minio                            ClusterIP      10.43.185.7     <none>        9000/TCP                5d4h
   minio               minio-console                    NodePort       10.43.45.84     <none>        9001:30485/TCP          5d4h
   minio               minio-svc                        ClusterIP      None            <none>        9000/TCP                5d4h
   ```

   Enter the server `IP+port` in your browser (ensure the port is opened in the security group if using a cloud host).
