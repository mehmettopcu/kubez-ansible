# Destroy Cluster

1. Execute the following command to clean up the Kubernetes cluster

    ```bash
    # multinode
    kubez-ansible -i multinode destroy --yes-i-really-really-mean-it

    # all-in-one
    kubez-ansible destroy --yes-i-really-really-mean-it
    ```

2. Restart the server or manually clean up residual information

    ```bash
    # Residual information mainly includes:
    iptables, ipvs, cni, etc.
    ```
