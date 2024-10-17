# Metrics Server Installation

## Prerequisites

- A properly functioning `kubernetes` environment. For installation manuals, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

### Installing Metrics Server Components

1. Edit `/etc/kubez/globals.yml`.

2. The configuration is set for default installation. If you do not want to install, uncomment `enable_metrics_server: "yes"` and set it to `"no"`.
    - Note: Setting it to "no" after installation will not be effective if the installation command is executed in step 3.

    ```shell
    #######################
    # Metrics Server Options
    #######################
    enable_metrics_server: "yes"
    ```

3. Execute the installation command (choose according to your situation).

    ```shell
    # Single node cluster scenario
    kubez-ansible apply

    # Multi-node & High Availability cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Validate after deployment.

    ```shell
    # All `metrics pods` are running normally
    [root@k8s-1 ~]# kubectl get pod -n kube-system
     NAME                                        READY   STATUS      RESTARTS   AGE
     metrics-server-v0.5.2-678db5756d-qlf7f      2/2     Running     0          22m
    [root@k8s-1 ~]# kubectl   top node
     NAME    CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
     k8s-1   514m         13%    9226Mi          59%
     k8s-2   528m         13%    11480Mi         73%
     k8s-3   448m         11%    10848Mi         69%
    ```
