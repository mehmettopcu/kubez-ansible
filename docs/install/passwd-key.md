# Writing Passwords/Keys in the Multinode Configuration File

- When there is only an `ssh_key` or only a regular user password, you can configure the `multinode` as follows:

  - To write the regular user's password in the configuration file:

      ```toml
      [docker-master]
      kube01 ansible_ssh_user=pixiu ansible_ssh_pass=pixiu123. ansible_become=true ansible_become_pass=pixiu123.

      # ansible_ssh_user: SSH connection user
      # ansible_ssh_pass: Password for the SSH connection user
      # ansible_become=true: Enable sudo command
      # ansible_become_pass: Password for the sudo user, default is root
      ```

  - To specify the node's `ssh_key` in the configuration file:

      ```toml
      [docker-master]
      kube01 ansible_user=root ansible_ssh_private_key_file=/root/root_key

      # ansible_ssh_private_key_file: SSH connection user's private key file
      # Key file permissions should be 600
      ```
