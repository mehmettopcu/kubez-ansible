# kafka-Operators Installation

## Prerequisites

- A functioning 'kubernetes' (v1.21+) environment. For installation instructions, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- The 'OLM' component must be installed in the cluster. For installation instructions, refer to [OLM Installation](../paas/olm.md).
- StorageClass

### Enable Rabbitmq-Operators Component

1. Edit '/etc/kubez/globals.yml'

2. Uncomment 'enable_kafka: "no"' and set it to '"yes"'. Uncomment 'kafka_name: kafka' to customize the Kafka cluster name. Uncomment 'kafka_namespace: operators' to customize the namespace.

    ```shell
    ###############
    # kafka Options
    ###############
    enable_kafka: "yes"

    kafka_name: kafka
    kafka_namespace: operators
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
    # rabbitmq has been registered in the cluster
    kubectl get csv -n operators
    [root@VM-4-3-centos ~]# kubectl get csv -n operators
    NAME                               DISPLAY   VERSION   REPLACES                           PHASE
    strimzi-cluster-operator.v0.33.0   Strimzi   0.33.0    strimzi-cluster-operator.v0.32.0   Succeeded

At this point, the 'kafka Operator' has been installed in the cluster. Next, let's demonstrate the creation of a 'kafka' instance.

### Create Kafka CR Instance

1. Modify the 'yaml' file (choose specific parameters based on your situation).

   ```yaml
    apiVersion: kafka.strimzi.io/v1beta2
    kind: Kafka
    metadata:
      name: my-cluster
    spec:
      kafka:
        version: 3.3.2
        replicas: 3
        listeners:
          - name: plain
            port: 9092
            type: internal
            tls: false
          - name: tls
            port: 9093
            type: internal
            tls: true
        config:
          offsets.topic.replication.factor: 3
          transaction.state.log.replication.factor: 3
          transaction.state.log.min.isr: 2
          default.replication.factor: 3
          min.insync.replicas: 2
          inter.broker.protocol.version: '3.3'
        storage:
          type: ephemeral
      zookeeper:
        replicas: 3
        storage:
          type: ephemeral
      entityOperator:
        topicOperator: {}
        userOperator: {}
   ```

2. Execute 'kubectl apply' to install the instance.

   ```shell
   # kafka-operator.yaml is the content shown in step 1
   kubectl apply -f kafka-operator.yaml
   ```

3. Verify after deployment.

   ```shell
   kubectl get po,sc,pv,pvc,secret
   [root@VM-4-3-centos ~]#
   NAME                                              READY   STATUS    RESTARTS      AGE
   pod/my-cluster-entity-operator-54b66cffc6-vhz7b   3/3     Running   0             27h
   pod/my-cluster-kafka-0                            1/1     Running   0             27h
   pod/my-cluster-kafka-1                            1/1     Running   0             27h
   pod/my-cluster-kafka-2                            1/1     Running   0             27h
   pod/my-cluster-zookeeper-0                        1/1     Running   1 (27h ago)   27h
   pod/my-cluster-zookeeper-1                        1/1     Running   0             27h
   pod/my-cluster-zookeeper-2                        1/1     Running   0             27h

   NAME                                            TYPE                                  DATA   AGE
   secret/default-token-hmjtt                      kubernetes.io/service-account-token   3      114d
   secret/demo-token-8zv4m                         kubernetes.io/service-account-token   3      23d
   secret/my-cluster-clients-ca                    Opaque                                1      27h
   secret/my-cluster-clients-ca-cert               Opaque                                3      27h
   secret/my-cluster-cluster-ca                    Opaque                                1      27h
   secret/my-cluster-cluster-ca-cert               Opaque                                3      27h
   secret/my-cluster-cluster-operator-certs        Opaque                                4      27h
   secret/my-cluster-entity-operator-token-vjmfh   kubernetes.io/service-account-token   3      27h
   secret/my-cluster-entity-topic-operator-certs   Opaque                                4      27h
   secret/my-cluster-entity-user-operator-certs    Opaque                                4      27h
   secret/my-cluster-kafka-brokers                 Opaque                                12     27h
   secret/my-cluster-kafka-token-m66jt             kubernetes.io/service-account-token   3      27h
   secret/my-cluster-zookeeper-nodes               Opaque                                12     27h
   secret/my-cluster-zookeeper-token-h7zxl         kubernetes.io/service-account-token   3      27h
   ```

4. Delete resources

- Delete the resources from step 3.

 ```shell
  kubectl delete -f kafka-operator.yaml
  ```

- Remove this Operator.

```shell
1. kubectl delete subscription <subscription-name> -n operators
2. kubectl delete clusterserviceversion -n operators
```

5. Detailed Documentation

```shell
https://github.com/chenghongxi/kubernetes-learning/blob/master/olm/kafka-operators/README.md
```
