# Helm3 Installation Guide

1. Configure `/etc/kubez/globals.yml` to enable Helm options (default is disabled).

    ```bash
    enable_helm: "yes"
    ```

2. Execute the following command to complete the installation of `helm3`.

    ```bash
    # multinode
    kubez-ansible -i multinode apply

    # all-in-one
    kubez-ansible apply
    ```

3. Verify the installation; you should see similar output.

    ```bash
    export KUBECONFIG=/etc/kubernetes/admin.conf

    helm version
    version.BuildInfo{Version:"v3.5.2", GitCommit:"167aac70832d3a384f65f9745335e9fb40169dc2", GitTreeState:"dirty", GoVersion:"go1.15.7"}
    ```
