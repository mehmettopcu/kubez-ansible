# Application Install Guides

1. Configure `/etc/kubez/globals.yml` to enable the desired `application` options.

    ```bash
    enable_<application_name>: "yes"
    ```

    Supported application names:
    - flannel
    - calico
    - metrics_server
    - nfs_provisioner
    - rbd_provisioner [ceph](ceph-guide.md)
    - dashboard
    - prometheus
    - efk
    - ingress_nginx
    - helm [helm3](helm3-guide.md)

2. Execute the following command to complete the installation of the specified `applications`.

    ```bash
    # multinode
    kubez-ansible -i multinode apply

    # all-in-one
    kubez-ansible apply
    ```

3. Perform your own verification.
