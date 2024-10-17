# MetalLB Installation

1. Configure `/etc/kubez/globals.yml` to enable the MetalLB option (default is off).

    ```bash
    enable_metallb: "yes"
    ```

2. You can customize the namespace (optional).

    ```bash
    metallb_namespace: "{{ kubez_namespace }}"

    # You can change this to a custom namespace, for example:

    metallb_namespace: "metallb-system"
    ```

3. Execute the following commands to complete the installation of `metallb`.

    ```bash
    # multinode
    kubez-ansible -i multinode apply

    # all-in-one
    kubez-ansible apply
    ```

4. Validate after deployment.

    ```bash
    pixiu-system   metallb-controller-64766bb9f9-qq88v         1/1     Running                 0              33m
    pixiu-system   metallb-speaker-tv6z2                       1/1     Running                 0              33m
    ```

5. Create an address pool (the YAML file provided on the official website is used to create an allocatable IP address pool) (Official site: <https://metallb.universe.tf/configuration/>).

    ```bash
    # The address-pools lists the IP addresses that MetalLB is
    # allowed to allocate. You can have as many
    # address pools as you want.
    apiVersion: metallb.io/v1beta1
    kind: IPAddressPool
    metadata:
        # A name for the address pool. Services can request allocation
        # from a specific address pool using this name.
        name: first-pool
        namespace: metallb-system
    spec:
        # A list of IP address ranges over which MetalLB has
        # authority. You can list multiple ranges in a single pool, they
        # will all share the same settings. Each range can be either a
        # CIDR prefix, or an explicit start-end range of IPs.
    addresses:
    - 192.168.10.0/24
    - 192.168.9.1-192.168.9.5
    - fc00:f853:0ccd:e799::/124
    Note:
    This file is for display only; the format may not be copied directly.
    The namespace of the address pool must be consistent with MetalLB.
    ```

6. Change the service type to LoadBalancer mode.

    ```bash
    # Check the existing service
    pixiu-system   grafana                              ClusterIP      10.254.69.87     <none>        80/TCP                       27s
    # Change the type field to LoadBalancer
    sessionAffinity: None
    type: ClusterIP
    # After modification
    sessionAffinity: None
    type: LoadBalancer
    ```

7. View the service after modification.

    ```bash
    pixiu-system   grafana                              LoadBalancer   10.254.69.87     192.168.10.1   80:30325/TCP                 20m
    ```
