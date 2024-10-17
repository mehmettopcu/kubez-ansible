# Bulk Enable Passwordless Login

## Prerequisites

- [Dependency Installation](prerequisites.md)
- Configure the deployment node's `/etc/hosts`, adding the IP and hostname resolution for the `kubernetes` nodes
- Complete the `multinode` configuration
- Dependency on the `sshpass` package

## Execution Steps

1. (Optional) Generate `id_rsa` and `id_rsa.pub` files

    ```bash
    # Enter the /root/.ssh folder and check if there are id_rsa and id_rsa.pub files. If they exist, skip this step; if not, execute the command below to generate them.
    ssh-keygen
    ```

2. Ensure `sshpass` is installed

    ```bash
    # CentOS
    # yum -y install sshpass
    # Ubuntu/Debian
    # apt-get install sshpass
    ```

3. Execute the following command to enable bulk passwordless login

    ```bash
    kubez-ansible -i multinode authorized-key
    ```

4. When prompted with `SSH password:`, enter the node password to complete the bulk enablement.

5. Login verification

    ```bash
    ansible -i multinode all -m ping

    # Successful output
    pixiu | SUCCESS => {
        "ansible_facts": {
            "discovered_interpreter_python": "/usr/bin/python"
        },
        "changed": false,
        "ping": "pong"
    }
    ```
