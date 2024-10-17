# Container Deployment

## Prerequisites

- [Docker Installation]()

### Configuration

- Create the configuration directory

```shell
mkdir -p /etc/kubez
```

- Global configuration

```shell
vim /etc/kubez/globals.yml
```

- Multinode grouping

```shell

# vim /etc/kubez/multinode

# Add username and password to the group

[docker-master]
pixiu01 ansible_ssh_user=root ansible_ssh_port=22 ansible_ssh_pass=123456 ansible_become_password=123456 ansible_become=true ansible_become_user=root
```

- Hostname resolution

```shell

# cat /etc/kubez/hosts

127.0.0.1 localhost
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

# BEGIN ANSIBLE GENERATED HOSTS

192.168.16.200 pixiu01
192.168.16.201 pixiu02

# END ANSIBLE GENERATED HOSTS

```

### Installation

```shell
docker run -d --name kubez-ansible-bootstrap-servers -e COMMAND=bootstrap-servers  -v /etc/kubez:/configs jacky06/kubez-ansible:v3.0.1
docker run -d --name kubez-ansible-deploy -e COMMAND=deploy -v /etc/kubez:/configs jacky06/kubez-ansible:v3.0.1
```

### Verify the Environment

   ```bash
   [root@kube01 ~]# kubectl get node
   NAME     STATUS   ROLES                  AGE     VERSION
   kube01   Ready    control-plane,master   21h     v1.23.6
   kube02   Ready    <none>                 21h     v1.23.6
   kube03   Ready    <none>                 3h48m   v1.23.6
   ```
