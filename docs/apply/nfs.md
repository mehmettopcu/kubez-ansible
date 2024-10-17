# NFS CSI Installation

## Prerequisites

- A properly functioning `kubernetes` environment. For installation manuals, refer to [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

## Enabling NFS Components

1. By default, `nfs csi` is enabled.

2. To disable `nfs csi`

   ```shell
   # Uncomment `enable_nfs_csi: "yes"` and set it to "no" to disable NFS
   #######################
   # StorageClass Options
   #######################
   enable_nfs_csi: "no"
   ```

3. Validate after deployment.

   ```shell
   [root@pixiu]# kubectl get pod -n kube-system
   NAME                                     READY   STATUS    RESTARTS   AGE
   csi-nfs-controller-6b468b7554-dvnfc         3/3     Running            0                  9d
   csi-nfs-node-vfm8m                          3/3     Running            0                  9d

   [root@pixiu]# kubectl get storageclass
   NAME                  PROVISIONER      RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
   managed-nfs-storage   nfs.csi.k8s.io   Delete          Immediate           false                  9d

   [root@pixiu]# kubectl get csidriver
   NAME                  ATTACHREQUIRED   PODINFOONMOUNT   STORAGECAPACITY   TOKENREQUESTS   REQUIRESREPUBLISH   MODES                  AGE
   nfs.csi.k8s.io        false            false            false             <unset>         false               Persistent             9d
   ```
