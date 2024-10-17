# Loggie

## Prerequisites

- A functioning `kubernetes` (v1.21+) environment. Refer to the installation manuals for [High Availability Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/multinode.md) or [Single Node Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/all-in-one.md).
- Loki.

## Enable Loggie Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_loggie: "no"` and set it to `"yes"`. Configure `loggie_loki_url` to the service `url` of Loki.

   ```yaml
    #################
    # Loggie Options
    #################
    enable_loggie: "yes"
    #loggie_namespace: "{{ kubez_namespace }}"

    #loggie_loki_url: http://loki-gateway/loki/api/v1/push
    # Helm repository configuration options
    #loggie_repo_name: "{{ default_repo_name }}"
    #loggie_repo_url: "{{ default_repo_url }}"
    #loggie_path: pixiuio/loggie
    #loggie_version: 1.4.0
   ```

3. Execute the installation command (choose according to your situation):

   ```yaml
   # Single node cluster scenario
   kubez-ansible apply

   # High availability cluster scenario
   kubez-ansible -i multinode apply
   ```

4. Validate after deployment:

   ```shell
   root@ubuntu:~# kubectl get pod -A | grep loggie
   pixiu-system   loggie-g484w                                         1/1     Running     0             17h
   ```
