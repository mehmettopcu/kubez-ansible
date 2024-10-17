# Zookeeper Installation

## Prerequisites

- A functioning 'kubernetes' (v1.21+) environment. For installation instructions, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- StorageClass.

## Enable Zookeeper Component

1. Edit '/etc/kubez/globals.yml'.

2. Uncomment 'enable_zookeeper: "no"', set it to '"yes"', and uncomment the following parameters.

    ```shell
   ######################
   # zookeeper
   ######################
   enable_zookeeper: "yes"
   # helm configuration
   #zookeeper_repository_name: "{{ default_repo_name }}"
   #zookeeper_repository_url: "{{ default_repo_url }}"
   #zookeeper_repository_path: "{{ default_repo_name }}/zookeeper"
   # zookeeper configuration
   zookeeper_replicas: 3
   #zookeeper_requests_cpu: 1
   #zookeeper_requests_memory: "1Gi"
   #zookeeper_namespace: "{{ kubez_namespace }}"
   #zookeeper_image_registry: "{{ app_image_repository }}"
   #zookeeper_image_repository: "zookeeper"
   #zookeeper_version: "11.4.9"
   # zookeeper persistence settings
   zookeeper_persistence_enabled: "true"
   #zookeeper_persistence_size: "8Gi"
   #zookeeper_persistence_storageclass: "{{ nfs_storage_class }}"
   #zookeeper_context_fsgroup: "0"
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
   [root@VM-0-16-ubuntu:/home/ubuntu]# kubectl get pod -n pixiu-system
   zookeeper-0                                 1/1     Running            0          16s
   zookeeper-1                                 1/1     Running            0          16s
   zookeeper-2                                 1/1     Running            0          16s
   [root@VM-0-16-ubuntu:/home/ubuntu]# kubectl get pvc -n pixiu-system
   NAME               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
   data-zookeeper-0   Bound    pvc-9723f14b-e87c-4276-ba6a-55497068757e   8Gi        RWO            managed-nfs-storage   3m23s
   data-zookeeper-1   Bound    pvc-5c73b82c-0312-4c67-8929-037d8fc1b0bb   8Gi        RWO            managed-nfs-storage   19s
   data-zookeeper-2   Bound    pvc-1b6e23f0-0f90-496a-a7ec-433796b5d06d   8Gi        RWO            managed-nfs-storage   19s
   ```

At this point, 'zookeeper' has been installed in the cluster.
