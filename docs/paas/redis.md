# Redis-Operator Installation

## Prerequisites

- A functioning 'kubernetes' (v1.21+) environment. For installation instructions, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- The cluster has the 'OLM' component installed. For installation instructions, refer to [OLM Installation](../paas/olm.md).
- StorageClass.

## Enable Redis-Operator Component

1. Edit '/etc/kubez/globals.yml'.

2. Uncomment 'enable_redis: "no"', set it to '"yes"', and uncomment the following parameters.

    ```shell
    ###############
    # Redis Options
    ###############
    enable_redis: "yes"

    redis_name: redis
    redis_namespace: operators
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
    # Redis has been registered in the cluster
    [root@VM-16-5-centos ~]# kubectl get csv -n operators
    NAME                       DISPLAY         VERSION        REPLACES                  PHASE
    redis-operator.v0.12.0     Redis Operator  0.12.0         redis-operator.v0.11.0    Succeeded
    ```

At this point, the 'Redis Operator' has been installed in the cluster. Next, let's demonstrate creating a 'Redis' instance.

## Create Redis CR Instance

1. Modify the 'yaml' file (adjust parameters as needed).

   ```yaml
   apiVersion: redis.redis.opstreelabs.in/v1beta1
   kind: RedisCluster
   metadata:
     name: redis-cluster
   spec:
     clusterSize: 3
     clusterVersion: v7
     securityContext:
       runAsUser: 1000
       fsGroup: 1000
     persistenceEnabled: true
     kubernetesConfig:
       image: 'quay.io/opstree/redis:v7.0.5'
       imagePullPolicy: IfNotPresent
     redisExporter:
       enabled: true
       image: 'quay.io/opstree/redis-exporter:v1.44.0'
       imagePullPolicy: IfNotPresent
     storage:
       # volumeClaimTemplate automatically creates pvc
       volumeClaimTemplate:
         spec:
           accessModes:
             - ReadWriteOnce
           # storageClassName automatically creates pv
           storageClassName: managed-nfs-storage
           resources:
             requests:
               storage: 1Gi
   ```

    - Change 'storageClassName' to an existing StorageClass.
    - Adjust 'storage' to the desired size.

2. Execute 'kubectl apply' to create the instance.

   ```shell
   # create-redis-cluster.yaml is the content shown in step 1
   [root@VM-16-5-centos manifests]# kubectl apply -f create-redis-cluster.yaml
   rediscluster.redis.redis.opstreelabs.in/redis-cluster created
   ```

3. Verify after deployment.

   ```shell
   # Check that all pods are running normally
   [root@VM-16-5-centos manifests]# kubectl get po
   NAME                         READY    STATUS        RESTART   AGE
   redis-cluster-follower-0     2/2      Running       0         8m31s
   redis-cluster-follower-1     2/2      Running       0         8m31s
   redis-cluster-follower-2     2/2      Running       0         8m31s
   redis-cluster-leader-0       2/2      Running       0         8m31s
   redis-cluster-leader-1       2/2      Running       0         8m31s
   redis-cluster-leader-2       2/2      Running       0         8m31s
   # Enter the pod to verify
   [root@VM-4-3-centos ~]# kubectl exec -it redis-cluster-leader-0 -- redis-cli -c cluster nodes
   Defaulted container "redis-cluster-leader" out of: redis-cluster-leader, redis-exporter
   2900d323ae4ff71ff4ceab0257196df4167ab6 172,30.142,32:637916379 slave ced685ff9fC309f5e01af69a31fd87a278b59 0 166979307000 3 connected
   ba6857a114e5674eba9d425hdcac56238 172,30.14230:637916379 slave 101d8533d900be6f11af864965729836ea6fhd9 0 1669799306822 1 connected
   101d8533d900be6+11a+8649655779836e36bd9 172.3.142.31:6379@16379 myself,master -9 1669799305000 1 connected 0-5460
   943094C18642604606773c476+c33e840168169 177.39.147.49:637901637g masten -9 16697993979997 connected5161-19922
   ced685++0fc309f5e01af60ca31+d87a2078650 172.39.142.35:6379@16379 master 1669799397099connected 10923-16383
   a2dd5798b448115ab62dab5581570076f41339cC 172.30.142.48:6379@16379 slave 5943094c186426046db773c476fc33e840168169 0 1669799306020 2 connected
   ```

4. Detailed documentation

   ```markdown
   https://github.com/chenghongxi/kubernetes-learning/blob/master/olm/redis-operators/README.md
   ```
