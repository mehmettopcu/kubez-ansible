# Offline Repository Preparation

- Construct an offline repository node to serve as the repository source for cluster nodes.
- Currently, only the `1.23.6` version of `Kubernetes` is supported.

## Obtaining the `Nexus` Offline Package

1. Automatic Retrieval

    ```shell
    # Repository node can connect to the internet
    curl -fL -u ptx9sk7vk7ow:003a1d6132741b195f332b815e8f98c39ecbcc1a "https://pixiupkg-generic.pkg.coding.net/pixiu/gopixiu-io/nexus.tar.gz?version=v2" -o nexus.tar.gz
    curl -fL -u ptx9sk7vk7ow:003a1d6132741b195f332b815e8f98c39ecbcc1a "https://pixiupkg-generic.pkg.coding.net/pixiu/gopixiu-io/k8soffimage.tar.gz?version=v2" -o k8soffimage.tar.gz
    curl -fL -u ptx9sk7vk7ow:003a1d6132741b195f332b815e8f98c39ecbcc1a "https://pixiupkg-generic.pkg.coding.net/pixiu/gopixiu-io/rpmpackages.tar.gz?version=v2" -o rpmpackages.tar.gz
    ```

2. Manual Retrieval

    ```shell
    # Cannot connect to the internet
    Copy nexus.tar.gz, k8soffimage.tar.gz, and rpmpackages.tar.gz to the working directory.
    ```

## Installing Nexus

1. Ensure the script [setup_registry.sh](https://github.com/gopixiu-io/kubez-ansible/blob/master/tools/setup_registry.sh) and `nexus.tar.gz` are in the same directory.

2. Set up the configuration file

    ```shell
    cat > k8senv.yaml << EOF
    # Please enter the IP of the current deployment machine; this must be modified.
    local_ip="localhost"

    # Domain name of the image repository where Nexus is deployed; can be left unchanged.
    regis_repos=registry.pixiu.com

    # Domain name of the Yum repository where Nexus is deployed; can be left unchanged.
    mirrors_repos=mirrors.pixiu.com
    EOF
    ```

3. Execute the installation

- Ensure that `nexus.tar.gz`, `k8senv.yaml`, `k8soffimage.tar.gz`, `rpmpackages.tar.gz`, and `setup_registry.sh` exist in the working directory and then execute:

    ```shell
    # Check
    [root@yum-server ~]# ls
    k8senv.yaml nexus.tar.gz setup_registry.sh k8soffimage.tar.gz rpmpackages.tar.gz

    # Installation
    [root@yum-server ~]# bash setup_registry.sh
    ```

4. Verify the deployment

    ```shell
    # Log in through the browser to check for the existence of images and installation packages.
    http://<ip>:50000 Username: admin Password: admin@AdMin123

    # TODO: Add image verification and RPM installation verification.
    ```
