# Rabbitmq-Operators Installation

## Prerequisites

- A functioning 'kubernetes' (v1.21+) environment. For installation instructions, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- The cluster has the 'OLM' component installed. For installation instructions, refer to [OLM Installation](../paas/olm.md).
- StorageClass.

### Enable Rabbitmq-Operators Component

1. Edit '/etc/kubez/globals.yml'.

2. Uncomment 'enable_postgres: "no"' and set it to '"yes"'.

    ```shell
    ##################
    # RabbitMQ Options
    ##################
    enable_rabbitmq: "yes"

    rabbitmq_name: rabbitmq
    rabbitmq_namespace: operators
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
    # RabbitMQ has been registered in the cluster
    kubectl get csv -n operators
    [root@VM-4-3-centos ~]# kubectl get csv -n operators
    NAME                                 DISPLAY                     version    REPLACES                           PHASE
    rabbitmq-cluster-operator.v2.0.0     RabbitMQ-cluster-operator   2.0.0      rabbitmq-cluster-operator.v1.14.0  Succeeded
    ```

At this point, the 'RabbitMQ Operator' has been installed in the cluster. Next, let's demonstrate creating a 'RabbitMQ' instance.

## Create RabbitMQ CR Instance

1. Modify the 'yaml' file (adjust parameters as needed).

   ```yaml
   apiVersion: rabbitmq.com/v1beta1
   kind: RabbitmqCluster
   metadata:
     name: rabbitmqcluster-sample
   spec:
     persistence:
       storageClassName: {{ storageClass }}
       storage: 1Gi
   ```

2. Execute 'kubectl apply' to create the instance.

   ```shell
   # rabbitmq-cluster-operator.yaml is the content shown in step 1
   kubectl apply -f rabbitmq-cluster-operator.yaml
   ```

3. Verify after deployment.

   ```shell
   kubectl get po,sc,pv,pvc,secret
   ```

4. Delete resources.
   - Delete the resources from step 3.

   ```shell
   kubectl delete -f create-rabbitmq-cluster.yaml
   ```

   - Delete this Operator.

   ```shell
   1. kubectl delete subscription <subscription-name> -n operators
   2. kubectl delete clusterserviceversion -n operators
   ```

5. Detailed documentation.

   ```shell
   https://github.com/chenghongxi/kubernetes-learning/blob/master/olm/rabbitmq-operators/README.md
   ```
