# Multi-Node Cluster

This document only covers the deployment of a scenario with 1 master and multiple nodes. For high availability of the master, refer to [High Availability Cluster Deployment](docs/install/availability.md).

## Prerequisites

- [Dependency Installation](prerequisites.md)

## Deployment Steps

1. Check the default network card configuration of the virtual machine:

   a. The default network card is `eth0`. If the actual network card in the environment is not `eth0`, you need to manually specify the network card name:

   ```bash
   Edit the /etc/kubez/globals.yml file, uncomment network_interface: "eth0", and change it to the actual network card name.
   ```

2. Confirm the connection address of the cluster environment:

   a. Internal network connection: No changes needed.

   b. Public network address:

   ```bash
   Edit the /etc/kubez/globals.yml file, uncomment #kube_vip_address: "172.16.50.250", and change it to the actual public address (for high availability scenarios, this will be the LB address). In a cloud environment, you need to allow the public IP to access port 6443 of the backend master node.
   ```

3. Configure the `multinode` configuration file in the working directory, adding host information based on the actual situation, and complete the following configurations:

    - Configure the deployment node's `/etc/hosts`, adding the IP and hostname resolution for the Kubernetes nodes.
    - The recommended format for multinode configuration:
      - If the `cri` selects Docker, only configure the [docker-master] and [docker-node]:

      ```shell
      [docker-master]
      kube01

      [docker-node]
      kube02

      [storage]
      kube01
      ```

      - If the `cri` selects Containerd, only configure the [containerd-master] and [containerd-node]:

      ```shell
      [containerd-master]
      kube01

      [containerd-node]
      kube02

      [storage]
      kube01
      ```

4. Enable passwordless login from the `deployment node` (the node running `kubez-ansible`) to other `node` nodes. [Enable Passwordless Login in Bulk](auth-key.md) or [Configure Password/Key](passwd-key.md).

5. (Optional) Modify the Kubernetes image repository:

    ```bash
    Edit the /etc/kubez/globals.yml file, changing image_repository: "" to the desired image repository. The default is Alibaba Cloud registry.cn-hangzhou.aliyuncs.com/google_containers.
    ```

6. (Optional) Modify the base application image repository:

    ```bash
    Edit the /etc/kubez/globals.yml file, changing app_image_repository: "" to the desired image repository. The default is the Pixiu image repository harbor.cloud.pixiuio.com/pixiuio.
    ```

7. Execute the following command to install the dependencies for Kubernetes:

    ```bash
    kubez-ansible -i multinode bootstrap-servers
    ```

8. Adjust the configuration file `/etc/kubez/globals.yml` as needed:

    ```bash
    cluster_cidr: "172.30.0.0/16"  # pod network
    service_cidr: "10.254.0.0/16"  # service network

    # network cni, currently supports flannel and calico, default is flannel
    enable_calico: "no"
    ```

9. Execute the following command to install the Kubernetes cluster:

    ```bash
    kubez-ansible -i multinode deploy
    ```

10. Verify the environment:

   ```bash
   [root@kube01 ~]# kubectl get node
   NAME     STATUS   ROLES                  AGE     VERSION
   kube01   Ready    control-plane,master   21h     v1.23.6
   kube02   Ready    <none>                 21h     v1.23.6
   kube03   Ready    <none>                 3h48m   v1.23.6
   ```

11. (Optional) Enable kubectl command line completion:

    ```bash
    kubez-ansible -i multinode post-deploy
    ```
