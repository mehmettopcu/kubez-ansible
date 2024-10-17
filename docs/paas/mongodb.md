# MongoDB-Operator Installation

### Prerequisites

- A functioning 'kubernetes' (v1.21+) environment. For installation instructions, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- The 'OLM' component must be installed in the cluster. For installation instructions, refer to [OLM Installation](../paas/olm.md).
- StorageClass

### Enable MongoDB-Operator Component

1. Edit '/etc/kubez/globals.yml'

2. Uncomment 'enable_mongodb: "no"' and set it to '"yes"'.

    ```shell
    ####################
    # MongoDB Options
    ####################
    enable_mongodb: "yes"

    mongodb_name: mongodb
    mongodb_namespace: operators
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
    # mongodb has been registered in the cluster
    [root@VM-16-5-centos manifests]# kubectl get deploy,csv -n operators
    NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/mongodb-operator   1/1     1            1           5m16s

    NAME                                                                 DISPLAY            VERSION   REPLACES   PHASE
    clusterserviceversion.operators.coreos.com/mongodb-operator.v0.3.0   MongoDB Operator   0.3.0                Succeeded
    ```

At this point, the 'MongoDB Operator' has been installed in the cluster. Next, let's demonstrate the creation of a 'MongoDB' instance.

### Create MongoDB CR Instance

1. Modify the 'yaml' file (choose specific parameters based on your situation).

   ```yaml
   ---
   apiVersion: v1
   kind: Secret
   type: Opaque
   metadata:
     name: mongodb-secret
   data:
     username: YWRtaW4=
     password: MTIzNDU2
   ---
   apiVersion: opstreelabs.in/v1alpha1
   kind: MongoDBCluster
   metadata:
     name: mongodb
   spec:
     clusterSize: 3
     kubernetesConfig:
       image: 'quay.io/opstree/mongo:v5.0.6'
       imagePullPolicy: IfNotPresent
       securityContext:
         fsGroup: 1001
     storage:
       accessModes:
         - ReadWriteOnce
       storageSize: 1Gi
       storageClass: managed-nfs-storage
     mongoDBSecurity:
       mongoDBAdminUser: admin
       secretRef:
         name: mongodb-secret
         key: password
   ```

- Change 'storageClassName' to an existing storage class.
- Change 'storage' to the required size.

2. Execute 'kubectl apply' to install the instance.

   ```shell
   # create-mongodb-cluster.yaml is the content shown in step 1
   [root@VM-16-5-centos manifests]# kubectl apply -f create-mongodb-cluster.yml
   secret/mongodb-secret unchanged
   mongodbcluster.opstreelabs.in/mongodb created
   ```

3. Verify after deployment.

   ```shell
   # pod, pv, pvc are all running normally
   [root@VM-16-5-centos manifests]# kubectl get po,pv,pvc
   NAME                    READY   STATUS    RESTARTS   AGE
   pod/mongodb-cluster-0   1/1     Running   0          2m17s
   pod/mongodb-cluster-1   1/1     Running   0          45s
   pod/mongodb-cluster-2   1/1     Running   0          28s

   NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                       STORAGECLASS          REASON   AGE
   persistentvolume/pvc-7a08ce1d-0f2c-40dd-8481-1891f123ca8f   1Gi        RWO            Delete           Bound    default/mongodb-cluster-mongodb-cluster-1   managed-nfs-storage            45s
   persistentvolume/pvc-8135dac1-edac-41e7-a834-a82f1840548f   1Gi        RWO            Delete           Bound    default/mongodb-cluster-mongodb-cluster-0   managed-nfs-storage            2m17s
   persistentvolume/pvc-a36504e9-88c1-4a6b-8bac-5841fdafe261   1Gi        RWO            Delete           Bound    default/mongodb-cluster-mongodb-cluster-2   managed-nfs-storage            28s

   NAME                                                      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
   persistentvolumeclaim/mongodb-cluster-mongodb-cluster-0   Bound    pvc-8135dac1-edac-41e7-a834-a82f1840548f   1Gi        RWO            managed-nfs-storage   2m17s
   persistentvolumeclaim/mongodb-cluster-mongodb-cluster-1   Bound    pvc-7a08ce1d-0f2c-40dd-8481-1891f123ca8f   1Gi        RWO            managed-nfs-storage   45s
   persistentvolumeclaim/mongodb-cluster-mongodb-cluster-2   Bound    pvc-a36504e9-88c1-4a6b-8bac-5841fdafe261   1Gi        RWO            managed-nfs-storage   28s

   # Enter pod for verification
   [root@VM-16-5-centos manifests]# kubectl exec -it mongodb-cluster-0 -- /bin/bash
   mongo@mongodb-cluster-0:/data/db$ mongo
   MongoDB shell version v5.0.6
   connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
   Implicit session: session { "id" : UUID("37dd9d46-b23e-4219-a396-af7a8a823730") }
   MongoDB server version: 5.0.6
   ================
   Warning: the "mongo" shell has been superseded by "mongosh",
   which delivers improved usability and compatibility. The "mongo" shell has been deprecated and will be removed in
   an upcoming release.
   For installation instructions, see
   https://docs.mongodb.com/mongodb-shell/install/
   ================
   Welcome to the MongoDB shell.
   For interactive help, type "help".
   For more comprehensive documentation, see
   https://docs.mongodb.com/
   Questions? Try the MongoDB Developer Community Forums
   https://community.mongodb.com
   > user pixiuDB
   uncaught exception: SyntaxError: unexpected token: identifier :
   @(shell):1:5
   >
   ```

4. Detailed Documentation

   ```shell
   https://github.com/chenghongxi/kubernetes-learning/blob/master/olm/mongodb-operators/README.md
   ```
