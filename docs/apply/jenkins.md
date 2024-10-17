# Jenkins Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manuals for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- StorageClass.

## Enable Jenkins Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_jenkins: "no"` and set it to `"yes"`:

    ```shell
    ##################
    # Jenkins Options
    ##################
    enable_jenkins: "yes"
    # Configure the namespace where the Jenkins instance runs
    # jenkins_namespace: "{{ kubez_namespace }}"
    # Configure the name of the StorageClass that Jenkins needs, in this example the StorageClass is managed-nfs-storage
    jenkins_storage_class: managed-nfs-storage
    # Configure the storage size that Jenkins needs
    jenkins_storage_size: 18Gi
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
    # Jenkins PVC allocation successful
    [root@pixiu tmp]# kubectl get pvc -n pixiu-system jenkins
    NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
    jenkins   Bound    pvc-c69ddac3-5b5e-4a2f-82bd-d2405e106d92   18Gi       RWO            managed-nfs-storage   22s

    # All Jenkins pods are running normally
    [root@pixiu tmp]# kubectl get pod -n pixiu-system jenkins-0
    NAME        READY   STATUS     RESTARTS   AGE
    jenkins-0   1/1     Running    0          65s
    ```

5. Access `Jenkins`:

    ```shell
    # Get the service information for Jenkins
    [root@pixiu tmp]# kubectl get svc -n pixiu-system jenkins
    NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
    jenkins   ClusterIP  10.254.231.203   <none>       8080/TCP        4h22m

    # If the Jenkins service is not of type NodePort, manually change it to NodePort
    # kubectl edit svc jenkins -n pixiu-system
      ...
      sessionAffinity: None
      type: NodePort

    # View the NodePort value
    [root@pixiu tmp]# kubectl get svc -n pixiu-system jenkins
    NAME      TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
    jenkins   NodePort   10.254.231.203   <none>       8080:30022/TCP   4h27m

    # At this point, the access address for Jenkins is `public_ip:30022`, which can be used to access Jenkins. The username and password are `admin`/`admin123456`. If you have changed the password, please use the updated password.
    ```
