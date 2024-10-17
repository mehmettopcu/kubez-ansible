# Tekton Installation

## Dependency Conditions

- A properly functioning `kubernetes` environment. For installation manuals, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

### Enabling Tekton Components

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_tekton: "no"` and set it to `"yes"`.

    ```shell
    ################
    # Tekton Options
    ###############
    enable_tekton: "yes"
    ```

3. Execute the installation command (choose according to your situation).

    ```shell
    # Single Node Cluster scenario
    kubez-ansible apply

    # High Availability Cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Validate after deployment.

    ```shell
    # Check Pod running status
    root@VM-0-9-ubuntu:~# kubectl get pod -A
    NAMESPACE                    NAME                                                 READY   STATUS      RESTARTS   AGE
    tekton-pipelines-resolvers   tekton-pipelines-remote-resolvers-7dd6dddf86-spzqh   1/1     Running     0          16s
    tekton-pipelines             tekton-dashboard-7d74d474f8-dfrxx                    1/1     Running     0          12s
    tekton-pipelines             tekton-pipelines-controller-57d9d77b4-n654v          1/1     Running     0          16s
    tekton-pipelines             tekton-pipelines-webhook-549fd99d48-s6n48            1/1     Running     0          16s
    ```

5. Access `Tekton`.

    ```shell
    # Get Tekton service information
    root@VM-0-9-ubuntu:~# kubectl get svc -n tekton-pipelines
    NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                              AGE
    tekton-dashboard              ClusterIP   10.254.127.248   <none>        9097/TCP                             2m18s
    tekton-pipelines-controller   ClusterIP   10.254.250.219   <none>        9090/TCP,8008/TCP,8080/TCP           2m23s
    tekton-pipelines-webhook      ClusterIP   10.254.243.71    <none>        9090/TCP,8008/TCP,443/TCP,8080/TCP   2m22s

    # You need to manually change the tekton-dashboard to NodePort type
    # root@VM-0-9-ubuntu:~# kubectl -n tekton-pipelines patch svc tekton-dashboard -p '{"spec":{"type":"NodePort"}}'
    service/tekton-dashboard patched

    # Check the NodePort value
    root@VM-0-9-ubuntu:~# kubectl get svc -n tekton-pipelines tekton-dashboard
    NAME          TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
    tekton-dashboard   NodePort   10.254.127.248   <none>        9097:31959/TCP   5m43s

    # At this point, the access address for tekton-dashboard is public_ip:31959, which allows you to access tekton-dashboard.
    ```
