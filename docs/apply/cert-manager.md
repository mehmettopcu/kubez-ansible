# Cert-manager Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

### Enable Cert-manager Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_cert_manager: "no"` and set it to `"yes"`.

3. Execute the installation command (choose based on your scenario).

    ```shell
    # Single node cluster scenario
    kubez-ansible apply

    # High availability cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Verify after deployment.

    ```shell
    # kubectl get pod -n pixiu-system
    NAME                                       READY   STATUS    RESTARTS   AGE
    cert-manager-584f85f6cf-wkbbc              1/1     Running   0          39s
    cert-manager-cainjector-6c58576757-gp4bw   1/1     Running   0          39s
    cert-manager-webhook-75d68f6fb9-8q2sq      1/1     Running   0          39s
    ```
