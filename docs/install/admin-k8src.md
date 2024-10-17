# Generate Kubernetes RC File

1. After completing the `Kubernetes` deployment, you need to import the KUBECONFIG into the environment variables:

    ```bash
    # For multinode setup
    kubez-ansible -i multinode post-deploy

    # For all-in-one setup
    kubez-ansible post-deploy
    ```

2. Verify the setup with the following commands, expecting similar output:

    ```bash
    . /root/admin-k8src.sh

    kubectl get node
    ```
