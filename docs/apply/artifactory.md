# Artifactory Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- StorageClass.

### Enable Artifactory Component

1. Edit `/etc/kubez/globals.yml`

2. Uncomment `enable_artifactory: "no"` and set it to `"yes"`

    ```shell
    ######################
    # Artifactory Options
    ######################
    enable_artifactory: "yes"

    # Configure the namespace in which the Artifactory instance runs
    #artifactory_namespace: "{{ kubez_namespace }}"

    # Configure the StorageClass name required by Artifactory; in this case, the StorageClass is managed-nfs-storage
    #artifactory_storage_class: managed-nfs-storage

    # Configure the storage size required by Artifactory
    #artifactory_size: "20Gi"
    # Configure the storage size required by PostgreSQL
    #postgresql_size: "20Gi"
    ```

3. Execute the installation command (choose according to your situation)

    ```shell
    # Single Node Cluster scenario
    kubez-ansible apply

    # High Availability Cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Verify after deployment

    ```shell
    # Artifactory pvc allocation succeeded
    root@VM-0-9-ubuntu:~# kubectl  get pvc -A
    NAMESPACE      NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS          AGE
    pixiu-system   artifactory-volume-artifactory-0   Bound    pvc-8e5c28cb-50ee-4306-adb1-4980bd1bc401   10Gi       RWO            managed-nfs-storage   75s
    pixiu-system   data-artifactory-postgresql-0      Bound    pvc-9ade00ca-4cc7-4ef4-be2c-4058d353aa69   10Gi       RWO            managed-nfs-storage   75s

    # Directory permissions for storage (since the Bitnami PostgreSQL container is a non-root container, the user with id 1001 needs write permissions on your mounted local folder)
    chown -R 1001:1001  /data/share/pvc-9ade00ca-4cc7-4ef4-be2c-4058d353aa69

    # You can find more information about this on the GitHub repository
    # https://github.com/bitnami/bitnami-docker-postgresql#persisting-your-database

    # Check the running status of Pods
    root@VM-0-9-ubuntu:~# kubectl  get pod -A
    pixiu-system   artifactory-0                                    8/8     Running                 9  (9d ago)     9d
    pixiu-system   artifactory-artifactory-nginx-85ff4d76b5-wwmj6   1/1     Running                 7  (9d ago)     9d
    pixiu-system   artifactory-postgresql-0                         1/1     Running                 15 (9d ago)     9d
    ```

5. Access `Artifactory`

    ```shell
    # Get the service information of Artifactory
    root@VM-0-9-ubuntu:~# kubectl get svc -n pixiu-system  artifactory
    NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
    artifactory   ClusterIP   10.254.42.238   <none>        8082/TCP,8081/TCP   9d

    # If the artifactory service is not of type NodePort, manually change it to NodePort
    # root@VM-0-9-ubuntu:~# kubectl edit svc artifactory -n pixiu-system
      ...
      sessionAffinity: None
      type: NodePort

    # Check the value of NodePort
    root@VM-0-9-ubuntu:~# kubectl get svc -n pixiu-system  artifactory
    NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
    artifactory   NodePort   10.254.42.238   <none>        8082:32558/TCP,8081:31773/TCP   9d

    # At this point, the access address for Artifactory is public_ip:32558, which allows access to Artifactory. The username and password are "admin/password".
    ```
