# Loki

## Prerequisites

- A functioning `kubernetes` (v1.21+) environment. Refer to the installation manuals for [High Availability Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/multinode.md) or [Single Node Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/all-in-one.md).
- StorageClass.
- Minio (create three buckets: chunks, ruler, admin).

## Enable Loki Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_loki: "no"` and set it to `"yes"`. Modify the S3-related parameters according to your environment.

   ```yaml
   ##############
   # Loki Options
   ##############
   enable_loki: "yes"

   # Storage class to be used
   loki_storage_class: managed-nfs-storage
   # Size of persistent disk
   loki_storage_size: 10Gi
   # Should authentication be enabled
   loki_auth_enabled: 'false'

   # Number of replicas
   loki_commonConfig_replication_factor_number: 2
   # Number of customized loki read-write replicas
   loki_read_replicas_number: 2
   loki_write_replicas_number: 2

   # Storage config
   loki_storage_bucketNames_chunks: chunks
   loki_storage_bucketNames_ruler: ruler
   loki_storage_bucketNames_admin: admin

   # S3 configuration
   s3:
     endpoint: http://172.17.16.13:9000
     secretAccessKey: minioadmin
     accessKeyId: minioadmin
     s3ForcePathStyle: true
     insecure: true
   ```

3. Execute the installation command (choose according to your situation):

   ```shell
   # Single node cluster scenario
   kubez-ansible apply

   # High availability cluster scenario
   kubez-ansible -i multinode apply
   ```

4. Validate after deployment:

   ```shell
   # All Loki pods are running normally
   [root@VM-16-13-centos ~]# kubectl get pods -n pixiu-system | grep loki
   loki-canary-c4twh                              1/1     Running   0          3h12m
   loki-canary-j7xsx                              1/1     Running   0          3h12m
   loki-gateway-7c76bc95dd-6s8g4                  1/1     Running   0          3h12m
   loki-grafana-agent-operator-5798474874-p6sz6   1/1     Running   0          3h12m
   loki-logs-4c58m                                2/2     Running   0          3h12m
   loki-logs-gjkm2                                2/2     Running   0          3h12m
   loki-read-0                                    1/1     Running   0          3h12m
   loki-read-1                                    1/1     Running   0          3h12m
   loki-write-0                                   1/1     Running   0          3h12m
   loki-write-1                                   1/1     Running   0          3h12m
   ```
