# Highly Available Cluster

## Prerequisites

- [Dependency Installation](prerequisites.md)

## Deployment Steps

1. Check the default network card configuration of the virtual machine

   a. The default network card is `eth0`. If the actual network card in the environment is not `eth0`, you need to manually specify the network card name:

   ```bash
    Edit the /etc/kubez/globals.yml file, uncomment network_interface: "eth0", and change it to the actual network card name.
   ```

2. Confirm the cluster environment connection address

   a. Internal connection:

   ```bash
   Edit the /etc/kubez/globals.yml file, uncomment #kube_vip_address: "172.16.50.250", and change it to the VIP address.
   ```

   b. Public connection:

   ```bash
   Edit the /etc/kubez/globals.yml file, uncomment #kube_vip_address: "172.16.50.250", and change it to the actual public address (LB address). In a cloud environment, you need to allow public IP access to the backend master node's 6443 port.
   ```

3. Configure the `multinode` configuration file in the working directory, add host information as needed, and complete the following configuration

    - Configure the deployment node's `/etc/hosts`, adding the IP and hostname resolution for the Kubernetes nodes.
    - Recommended format for multinode configuration:
      - If CRI is Docker, configure only [docker-master] and [docker-node]:

      ```toml
      # If it is a highly available cluster, add an odd number of hostnames to [docker-master].
      [docker-master]
      kube01
      kube02
      kube03

      [docker-node]
      kube0x
      kube0x
      kube0x

      [storage]
      kube01
      ```

      - If CRI is containerd, configure only [containerd-master] and [containerd-node]:

      ```toml
      # If it is a highly available cluster, add an odd number of hostnames to [containerd-master].
      [containerd-master]
      kube01
      kube02
      kube03

      [containerd-node]
      kube0x
      kube0x
      kube0x

      [storage]
      kube01
      ```

4. Enable passwordless login from the `deployment node` (the node running `kubez-ansible`) to other `node` nodes [Enable Passwordless Login in Bulk](auth-key.md) or [Configure Password/Key](passwd-key.md)

5. (Optional) Modify the Kubernetes image repository

    ```bash
    Edit the /etc/kubez/globals.yml file, change image_repository: "" to the desired image repository. The default is Alibaba Cloud registry.cn-hangzhou.aliyuncs.com/google_containers.
    ```

6. (Optional) Modify the base application image repository

    ```bash
    Edit the /etc/kubez/globals.yml file, change app_image_repository: "" to the desired image repository. The default is the Pixiu image repository harbor.cloud.pixiuio.com/pixiuio.
    ```

7. Execute the following command to install the dependencies for `kubernetes`

    ```bash
    kubez-ansible -i multinode bootstrap-servers
    ```

8. Adjust the configuration file `/etc/kubez/globals.yml` as needed

    ```bash
    enable_kubernetes_ha: "yes"  # Enable multi-controller high availability, ensure that the control group in multinode is an odd number.
    kube_vip_address: "x.x.x.x"  # If it is a public LB, fill in the public LB address; if it is self-built high availability, fill in the VIP.
    enable_haproxy: "yes"        # Deploy haproxy and keepalived; if using a public LB, this does not need to be enabled.

    # When enabling haproxy + keepalived, it is recommended to use port 8443 for listening.
    kube_vip_port: 6443

    cluster_cidr: "172.30.0.0/16"  # Pod network
    service_cidr: "10.254.0.0/16"  # Service network

    # Network CNI, currently supports flannel and calico, default is flannel.
    enable_calico: "no"
    ```

9. Execute the following command to install the `kubernetes` cluster

    ```bash
    kubez-ansible -i multinode deploy
    ```

10. Verify the environment

   ```bash
   [root@kube01 ~]# kubectl get node
   NAME     STATUS   ROLES                  AGE     VERSION
   kube01   Ready    control-plane,master   21h     v1.23.6
   kube02   Ready    <none>                 21h     v1.23.6
   kube03   Ready    <none>                 3h48m   v1.23.6
   ```

11. (Optional) Enable kubectl command-line completion

    ```bash
    kubez-ansible -i multinode post-deploy
    ```
