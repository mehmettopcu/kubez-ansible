# Cilium & Hubble

## Prerequisites

- A functioning `kubernetes` (v1.21+) environment. Refer to the installation manual for [High Availability Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/multinode.md) or [Single Node Cluster](https://github.com/gopixiu-io/kubez-ansible/blob/master/docs/install/all-in-one.md).
- Linux kernel >= 4.9.17

## Enable Cilium Component

1. Edit `/etc/kubez/globals.yml`

2. Uncomment `enable_cilium: "no"` and set it to `"yes"`, and set Cilium's version to `cilium_chart_version: "1.16.1"`

   ```yaml
   ################
   # Cilium Options
   ################
   enable_cilium: "yes"
   cilium_chart_version: "1.14.5"
   ```

3. Execute the installation command (choose based on your scenario)

   ```shell
   # Single node cluster scenario
   kubez-ansible apply
   # High availability cluster scenario
   kubez-ansible -i multinode apply
   ```

4. Verify after deployment

   ```shell
   [root@VM-16-11-centos ~]# kubectl get pods -n kube-system
   NAME                                    READY   STATUS    RESTARTS   AGE
   cilium-operator-cb4578bc5-q52qk         1/1     Running   0          4m13s
   cilium-s8w5m                            1/1     Running   0          4m12s
   ```
