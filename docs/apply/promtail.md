# Promtail

## Dependency Conditions

- A properly functioning `kubernetes` (v1.21+) environment. For installation manuals, refer to [High Availability Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/multinode.md) or [Single Node Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/all-in-one.md).
- Loki

## Enabling Promtail Components

1. Edit `/etc/kubez/globals.yml`

2. Uncomment `enable_promtail: "no"` and set it to `"yes"`, and configure `loki_url` to the Loki service URL.

   ```yaml
   ##################
   # Promtail Options
   ##################
   enable_promtail: "yes"

   # Loki server URL for push
   loki_url: http://loki-gateway/loki/api/v1/push
   ```

3. Execute the installation command (choose according to your situation)

   ```yaml
   # Single Node Cluster scenario
   kubez-ansible apply

   # High Availability Cluster scenario
   kubez-ansible -i multinode apply
   ```

4. Validate after deployment

   ```shell
   [root@VM-16-13-centos ~]# kubectl get pods -n pixiu-system | grep promtail
   promtail-jzg96                                 1/1     Running   0          179m
   promtail-q829g                                 1/1     Running   0          179m
   ```
