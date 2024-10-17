# Cluster Expansion

1. Configure the `multinode` in the working directory, adding the nodes to be expanded to the `cri` group based on the actual situation, and complete the following configuration:

    - Enable passwordless login from the deployment node to the new node [Enable Passwordless Login in Bulk](auth-key.md)

    - Configure the deployment node's `/etc/hosts`, adding the IP and hostname resolution for the new node (this example uses the newly added `kube03`), with the `multinode` configuration format:
    - If `cri` selects `docker`,

            ```toml
            # Only configure the [docker-master] and [docker-node] groups
            [docker-master]
            kube01

            [docker-node]
            kube03
            ```

    - If `cri` selects `containerd`

            ```toml
            # Only configure the [containerd-master] and [containerd-node]
            [containerd-master]
            kube01

            [containerd-node]
            kube03
            ```

2. Execute the following command to install the dependencies for Kubernetes:

    ```bash
    kubez-ansible -i multinode bootstrap-servers
    ```

3. Execute the following command to install the Kubernetes cluster:

    ```bash
    kubez-ansible -i multinode deploy
    ```
