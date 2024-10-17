# OLM Installation

## Prerequisites

- A functioning `kubernetes` (v1.17+) environment. Refer to the installation manuals for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

## Enable OLM Components

1. Edit `/etc/kubez/globals.yml`

2. Uncomment `enable_olm: "no"` and set it to `"yes"`

    ```yaml
    ####################################
    # Operator-Lifecycle-Manager Options
    ####################################
    enable_olm: "yes"
    ```

3. Execute the installation command (choose according to your situation)

    ```shell
    # Single node cluster scenario
    kubez-ansible apply

    # High availability cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Verify deployment

    ```shell
    # All OLM pods are running normally
    [root@VM-32-9-centos ~]# kubectl get pod -n olm
    NAME                                READY   STATUS        RESTARTS   AGE
    catalog-operator-755d759b4b-lwhjz   1/1     Running       0          2m6s
    olm-operator-c755654d4-br2qz        1/1     Running       0          2m6s
    operatorhubio-catalog-lzccq         1/1     Running       0          91s
    packageserver-599f7fb5fd-x5w4s      1/1     Running       0          94s
    packageserver-599f7fb5fd-zkrkx      1/1     Running       0          94s
    ```
