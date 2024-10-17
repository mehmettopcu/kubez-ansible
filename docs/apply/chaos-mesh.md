# Chaos Mesh Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).
- StorageClass.

### Enable Chaos Mesh Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_chaos_mesh: "no"` and set it to `"yes"`.

    ```shell
    ####################
    # Chaos Mesh Options
    ####################
    enable_chaos_mesh: "yes"
    #chaos_mesh_name: chaos-mesh
    #chaos_mesh_namespace: "{{ kubez_namespace }}"
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
    # kubectl get pod -n pixiu-system
    chaos-controller-manager-6f75cdf4f9-62fmh   0/1     ContainerCreating   0             6m24s
    chaos-controller-manager-6f75cdf4f9-klxq2   0/1     ContainerCreating   0             6m24s
    chaos-controller-manager-6f75cdf4f9-mpvfd   0/1     ContainerCreating   0             6m24s
    chaos-daemon-mpqkx                          0/1     ContainerCreating   0             6m24s
    chaos-daemon-znpxg                          0/1     ContainerCreating   0             6m24s
    chaos-dashboard-7684ff75f4-67lrd            0/1     ContainerCreating   0             6m24s
    chaos-dns-server-76d5d8f776-pbpj7           0/1     ContainerCreating   0             6m24s
    ```
