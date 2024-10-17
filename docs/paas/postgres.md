# Postgres-Operator Installation

## Prerequisites

- A functioning 'kubernetes' (v1.21+) environment. For installation instructions, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- The cluster has the 'OLM' component installed. For installation instructions, refer to [OLM Installation](../paas/olm.md).
- StorageClass.

### Enable Postgres-Operator Component

1. Edit '/etc/kubez/globals.yml'.

2. Uncomment 'enable_postgres: "no"' and set it to '"yes"'.

    ```shell
    ##################
    # Postgres Options
    ##################
    enable_postgres: "yes"

    postgres_name: postgres
    postgress_namespace: operators
    ```

3. Execute the installation command (choose based on your situation).

    ```shell
    # Single Node Cluster Scenario
    kubez-ansible apply

    # High Availability Cluster Scenario
    kubez-ansible -i multinode apply
    ```

4. Verify after deployment.

    ```shell
    # Postgres has been registered in the cluster
    [root@VM-16-5-centos ~]# kubectl get deploy,csv -n operators
    NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/pgo   1/1     1            1           116m

    NAME                                                                 DISPLAY                           VERSION   REPLACES                  PHASE
    clusterserviceversion.operators.coreos.com/postgresoperator.v5.3.0   Crunchy Postgres for Kubernetes   5.3.0     postgresoperator.v5.2.0   Succeeded
    ```

At this point, the 'Postgres Operator' has been installed in the cluster. Next, let's demonstrate creating a 'Postgres' instance.

## Create Postgres CR Instance

1. Modify the 'yaml' file (adjust parameters as needed).

   ```yaml
   apiVersion: postgres-operator.crunchydata.com/v1beta1
   kind: PostgresCluster
   metadata:
     name: hippo
   spec:
     image: registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-14.5-1
     postgresVersion: 14
     instances:
       - name: instance1
         replicas: 1
         dataVolumeClaimSpec:
           accessModes:
             - "ReadWriteOnce"
           storageClassName: "managed-nfs-storage"
           resources:
             requests:
               storage: 1Gi
     backups:
       pgbackrest:
         image: registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.40-1
         repos:
           - name: repo1
             volume:
               volumeClaimSpec:
                 accessModes:
                   - "ReadWriteOnce"
                 storageClassName: "managed-nfs-storage"
                 resources:
                   requests:
                     storage: 1Gi
   ```

    - Change 'storageClassName' to an existing storage class.
    - Adjust 'storage' to the required size.

2. Execute 'kubectl apply' to create the instance.

   ```shell
   # create-postgres-cluster.yaml is the content shown in step 1
   [root@VM-16-5-centos manifests]# kubectl apply -f create-postgres-cluster.yaml
   postgrescluster.postgres-operator.crunchydata.com/hippo created
   ```

3. Verify after deployment.

   ```shell
   # Pods are running normally
   [root@VM-16-5-centos manifests]# kubectl get po,pv,pvc
   NAME                          READY   STATUS      RESTARTS   AGE
   pod/hippo-backup-7gcg-zx684   0/1     Completed   0          3m26s
   pod/hippo-instance1-crq2-0    4/4     Running     0          7m37s
   pod/hippo-repo-host-0         2/2     Running     0          7m37s

   NAME                                                        CAPACITY    ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                 STORAGECLASS          REASON   AGE
   persistentvolume/pvc-ba6958d7-3fc7-4a9c-bd69-4cb9d8d7c291   1Gi        RWO            Delete           Bound    default/hippo-repo1                   managed-nfs-storage            7m37s
   persistentvolume/pvc-d2bcb0b3-9d7d-4e11-8bae-a74e62b3ad64   1Gi        RWO            Delete           Bound    default/hippo-instance1-crq2-pgdata   managed-nfs-storage            7m37s

   NAME                                                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
   persistentvolumeclaim/hippo-instance1-crq2-pgdata   Bound    pvc-d2bcb0b3-9d7d-4e11-8bae-a74e62b3ad64   1Gi        RWO            managed-nfs-storage   7m37s
   persistentvolumeclaim/hippo-repo1                   Bound    pvc-ba6958d7-3fc7-4a9c-bd69-4cb9d8d7c291   1Gi        RWO            managed-nfs-storage   7m37s

   # Enter the pod for verification
   [root@VM-4-3-centos ~]# kubectl exec -it hippo-instance1-zw2j-0 -- /bin/bash
   Defaulted container "database" out of: database, replication-cert-copy, pgbackrest, pgbackrest-config, postgres-startup (init), nss-wrapper-init (init)
   psql (14.5)
   Type "help" for help.
   postgres=#
   ```

4. Detailed documentation.

   ```shell
   https://github.com/chenghongxi/kubernetes-learning/blob/master/olm/postgres-Operators/README.md
   ```
