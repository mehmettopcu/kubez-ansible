# Grafana Installation

## Prerequisites

- A functioning `kubernetes` (v1.21+) environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

## Common Templates

- [Node_Exporter](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
- [Kubernetes ApiServer](https://grafana.com/grafana/dashboards/12006-kubernetes-apiserver/)
- [ETCD](https://grafana.com/grafana/dashboards/3070-etcd/)
- [Nginx Ingress Controller](https://grafana.com/grafana/dashboards/9614-nginx-ingress-controller/)
- [Loki](https://grafana.com/grafana/dashboards/14055-loki-stack-monitoring-promtail-loki/)

## Enable Grafana Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_grafana: "no"` and set it to `"yes"`.

    ```shell
    ##################
    # Grafana Options
    ##################
    enable_grafana: "yes"

    grafana_admin_user: admin
    grafana_admin_password: admin
    ```

3. Execute the installation command (choose based on your scenario).

    ```shell
    # Single node cluster scenario
    kubez-ansible apply
    # High availability cluster scenario
    kubez-ansible -i multinode apply
    ```

4. Verify after deployment.

    ```shell
    [root@VM-0-16-centos ~]# kubectl get pod -n pixiu-system
    NAME                      READY   STATUS    RESTARTS   AGE
    grafana-b96497f76-fmrdf   1/1     Running   0          22m

    [root@VM-0-16-centos ~]# helm list -n pixiu-system
    NAME        NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
    grafana     pixiu-system    1               2023-03-05 17:07:34.860715012 +0800 CST deployed        grafana-6.29.6  8.5.3
    ```
