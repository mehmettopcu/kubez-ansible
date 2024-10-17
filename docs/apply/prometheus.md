# Prometheus

## Deploying K8S

- A properly functioning `kubernetes` (1.17+) environment. For installation manuals, refer to [High Availability Cluster](https://github.com/caoyingjunz/kubez-ansible/blob/master/docs/install/multinode.md) or [Single Node Cluster](https://github.com/caoyingjunz/kubez-ansible/blob/master/docs/install/all-in-one.md).

## Enabling Prometheus Components

Edit `/etc/kubez/globals.yml`  
Uncomment `enable_prometheus: "no"` and set it to `"yes"`.

```sh
# Grafana will also be deployed when Prometheus is enabled.
enable_prometheus: "yes"
```

## Validation

```sh
[root@k8s-151 ~]# kubectl get pods -A | grep prometheus
pixiu-system    prometheus-alertmanager-55ff5486b8-6xfx9         2/2     Running     10 (95s ago)   20h
pixiu-system    prometheus-kube-state-metrics-5d7c465bbd-cbx4q   1/1     Running     5 (95s ago)    20h
pixiu-system    prometheus-node-exporter-kvkc7                   1/1     Running     5 (95s ago)    20h
pixiu-system    prometheus-pushgateway-6475d4bbcc-lj6f5          1/1     Running     5 (95s ago)    20h
pixiu-system    prometheus-server-5bc886d8bf-7c9b2               2/2     Running     10 (95s ago)   20h
```

## (Optional) Prometheus Alerts

[Prometheus Alerts](https://awesome-prometheus-alerts.grep.to/)

## Ingress Configuration

### Step 1: Edit the YAML file

```sh
cat monitoring-ingress.yaml

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  labels:
    app: grafana
  name: grafana
  namespace: pixiu-system
spec:
  ingressClassName: nginx
  rules:
    - host: k8s-grafana.pixiu.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: grafana
                port:
                  number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  labels:
    app: prometheus
    prometheus: k8s
  name: prometheus-k8s
  namespace: pixiu-system
spec:
  ingressClassName: nginx
  rules:
    - host: k8s-prom.pixiu.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-server
                port:
                  number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  labels:
    app: alertmanager
    prometheus: k8s
  name: alertmanager
  namespace: pixiu-system
spec:
  ingressClassName: nginx
  rules:
    - host: k8s-alertm.pixiu.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-alertmanager
                port:
                  number: 80
```

### Step 2: Expose Prometheus and Grafana in Ingress

```sh
kubectl apply -f 3.monitoring-ingress.yaml
```

### Step 3: Configure local hosts resolution and validate

```sh
[root@k8s-151 ~]# kubectl get ing -A
NAMESPACE      NAME             CLASS   HOSTS                   ADDRESS      PORTS   AGE
pixiu-system   alertmanager     nginx   k8s-alertm.pixiu.com    10.0.0.115   80      13h
pixiu-system   grafana          nginx   k8s-grafana.pixiu.com   10.0.0.115   80      13h
pixiu-system   prometheus-k8s   nginx   k8s-prom.pixiu.com      10.0.0.115   80      13h
```

## Get Grafana Password

```sh
kubectl get secret -n pixiu-system grafana -o yaml | grep password | awk '{ print $2 }' | base64 -d
```
