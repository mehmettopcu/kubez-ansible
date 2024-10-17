# Single Node Cluster

## System Requirements

- `1 CPU core, 2GB RAM or more`

## Prerequisites

- [Install Dependencies](prerequisites.md)

## Deployment Steps

1. **Check the default network interface configuration of the virtual machine**
   - The default network interface is `eth0`. If the actual network interface in your environment is not `eth0`, you need to manually specify the correct interface name:

     ```bash
     Edit the file `/etc/kubez/globals.yml`, uncomment the line `network_interface: "eth0"`, and change it to the actual interface name.
     ```

2. **Confirm the cluster connection address**

   - **Internal network connection**: No changes needed.
   - **Public network connection**:

     ```bash
     Edit the file `/etc/kubez/globals.yml`, uncomment the line `#kube_vip_address: ""`, and set it to the actual public IP address. Ensure that port `6443` is open to the public IP on cloud platform environments.
     ```

3. **(Optional) Change the default Container Runtime Interface (CRI)**
   - The default CRI is `containerd`. If you want to switch to `docker`:
     - For `CentOS`, edit `/usr/share/kubez-ansible/ansible/inventory/all-in-one`
     - For `Ubuntu`, edit `/usr/local/share/kubez-ansible/ansible/inventory/all-in-one`
   - Remove the host information for `containerd-master` and `containerd-node`, and add the nodes under the `docker` group. The result should look like this:

     ```toml
     [docker-master]
     localhost       ansible_connection=local

     [docker-node]
     localhost       ansible_connection=local

     [containerd-master]

     [containerd-node]
     ```

4. **(Optional) Change the Kubernetes image repository**

    ```bash
    Edit the file `/etc/kubez/globals.yml`, and modify `image_repository: ""` to the desired image repository. The default is Aliyun `registry.cn-hangzhou.aliyuncs.com/google_containers`.
    ```

5. **(Optional) Change the base application image repository**

   ```bash
   Edit the file `/etc/kubez/globals.yml`, and modify `app_image_repository: ""` to the desired repository. The default is Pixiu’s repository `harbor.cloud.pixiuio.com/pixiuio`.
   
6. **Install Kubernetes dependencies**

    ```bash
    kubez-ansible bootstrap-servers
    ```

7. **Deploy the Kubernetes cluster**

    ```bash
    kubez-ansible deploy
    ```

8. **Verify the environment**

    ```bash
    kubectl get node
    NAME    STATUS   ROLES    AGE    VERSION
    pixiu   Ready    master   134d   v1.23.6
    ```

9. **(Optional) Enable `kubectl` command-line autocompletion**

    ```bash
    kubez-ansible post-deploy
    ```
