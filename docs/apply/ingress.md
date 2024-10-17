# Ingress Nginx Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

### Install Ingress Nginx Component

1. Edit `/etc/kubez/globals.yml`.

2. The configuration is set to install by default. If you do not want to install, uncomment `enable_ingress_nginx: "yes"` and set it to `"no"`.
    - Note: Setting it to `no` after installation and then executing step 3 will be ineffective.

    ```shell
    #######################
    # Ingress Nginx Options
    #######################
    enable_ingress_nginx: "yes"
    ```

3. Execute the installation command (choose based on your scenario).

    ```shell
    # Single node cluster scenario
    kubez-ansible apply

    # High availability cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Verification after deployment.

    ```shell
    # All `ingress pods` are running normally
    [root@VM-32-9-centos ~]# kubectl get pod -n kube-system
    NAMESPACE       NAME                                        READY   STATUS      RESTARTS      AGE
    kube-system     ingress-nginx-admission-create-kvrkq        0/1     Completed   0             4d3h
    kube-system     ingress-nginx-admission-patch-999z9         0/1     Completed   5             4d3h
    kube-system     ingress-nginx-controller-58c95c57d4-lklsj   1/1     Running     2 (17h ago)   4d2h
    ```

5. (Optional) Set the host machine's `IP` as the entry for `ingress` — suitable for scenarios without `LB` but wanting to use `Ingress`.
    - Edit `/tmp/pixiuspace/ingress-nginx.yml` to add `hostNetwork: true` configuration.

    ```shell
        ...
        spec:
          ...
          hostNetwork: true
          ...
    ```

    - Apply the configuration file.

    ```shell
       kubectl apply -f /tmp/pixiuspace/ingress-nginx.yml -n kube-system
    ```
