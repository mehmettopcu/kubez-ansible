# kubez-ansible Component Integration Manual

## 1: Integration Instructions (Using Jenkins as an Example)

### 1.1: Find Jenkins at <https://artifacthub.io>

![image](https://github.com/gitlayzer/images/assets/77761224/d7f45a43-1c25-4132-b4d7-96a9441beb1a)

### 1.2: Let's take a look at its values file

![image](https://github.com/gitlayzer/images/assets/77761224/02821dc0-1788-4660-90c2-80aded599540)
![image](https://github.com/gitlayzer/images/assets/77761224/b7a270aa-bd86-40c2-a350-4221ab0b40ce)

### Here, we extract the key-value pairs we need. You can manually use Helm to install it first and see which default modifiable key-value pairs are available

```yaml
jenkins:
  name: jenkins
  namespace: "{{ jenkins_namespace }}"
  repository:
    name: jenkinsci
    url: https://charts.jenkins.io/
  chart:
    path: jenkinsci/jenkins
    version: 4.2.20
  chart_extra_vars:
    persistence.storageClass: "{{ jenkins_storage_class }}"
    persistence.size: "{{ jenkins_storage_size }}"
    controller.adminPassword: "{{ initial_admin_password }}"
```

### This configuration file needs to be written into `kubez-ansible` in `ansible/group_vars/all.yml`

```yaml
# ################## Note that some of the indentations and affiliations in the configuration of this file, the above YAML needs to be placed at the top of the file as follows ##################
charts:
  # Here are the parameters to pass for the Charts of the application we want to integrate
  jenkins:
    name: jenkins
    namespace: "{{ jenkins_namespace }}"
    repository:
      name: "{{ jenkins_repo_name }}"
      url: "{{ jenkins_repo_url }}"
    chart:
      path: "{{ jenkins_path }}"
      version: "{{ jenkins_version }}"
    chart_extra_vars:
      persistence.storageClass: "{{ jenkins_storage_class }}"
      persistence.size: "{{ jenkins_storage_size }}"
      controller.adminPassword: "{{ initial_admin_password }}"
```

### 1.3: Also compile a Jenkins configuration item in `all.yml`

```yaml
##################
# Jenkins Options
##################
enable_jenkins: "no"

# This section corresponds to the variables in the charts above, defaults to those in the chart and can be modified by the user
jenkins_namespace: "{{ kubez_namespace }}"
jenkins_storage_class: managed-nfs-storage
jenkins_storage_size: "8Gi"
# The initial password for admin
initial_admin_password: "admin123456"
```

### 1.4: There is also a configuration to enable this item, which needs to be set in `enable_charts`

```yaml
enable_charts:
  - name: jenkins
    enabled: "{{ enable_jenkins | bool }}"
```

### 1.5: Finally, our configuration in `all.yml` looks like this

```yaml
##################
# Jenkins Options
##################
enable_jenkins: "no"

jenkins_namespace: "{{ kubez_namespace }}"
jenkins_storage_class: managed-nfs-storage
jenkins_storage_size: "8Gi"

# The initial password for admin
initial_admin_password: "admin123456"

# Helm repository configuration
jenkins_repo_name: "{{ default_repo_name }}"
jenkins_repo_url: "{{ default_repo_url }}"
jenkins_path: pixiuio/jenkins
jenkins_version: 4.12.0

enable_charts:
  - name: jenkins
    enabled: "{{ enable_jenkins | bool }}"

charts:
  # Here are the parameters to pass for the Charts of the application we want to integrate
  jenkins:
    name: jenkins
    namespace: "{{ jenkins_namespace }}"
    repository:
      name: "{{ jenkins_repo_name }}"
      url: "{{ jenkins_repo_url }}"
    chart:
      path: "{{ jenkins_path }}"
      version: "{{ jenkins_version }}"
    chart_extra_vars:
      persistence.storageClass: "{{ jenkins_storage_class }}"
      persistence.size: "{{ jenkins_storage_size }}"
      controller.adminPassword: "{{ initial_admin_password }}"
```

### 1.6: Our final action is to add Jenkins to the `etc/kubez/globals.yml` file

```yaml
# It’s not hard to see that we have placed the Jenkins configuration from `ansible/group_vars/all.yml` here.
# If we remove the comments, it proves that we need to integrate Jenkins.
# Otherwise, Jenkins will not be integrated.

##################
# Jenkins Options
##################
#enable_jenkins: "no"
#jenkins_namespace: "{{ kubez_namespace }}"
#jenkins_storage_class: managed-nfs-storage
#jenkins_storage_size: 8Gi

# The initial password for admin
#initial_admin_password: admin123456

# Helm repository configuration, defaults to pixiu helm chart repository
#jenkins_repo_name: "{{ default_repo_name }}"
#jenkins_repo_url: "{{ default_repo_url }}"
#jenkins_path: pixiuio/jenkins
#jenkins_version: 4.12.0
```

## 2: If Using YAML Files to Deploy the Project

### 2.1: If using YAML files to deploy the project, simply add the YAML file to `ansible/roles/kubernetes/templates/xxxx.yml.j2`

### 2.2: Then add the following configuration in the `all.yml` file

```yaml
# The following is an example; please refer to the actual integrated project.

###############
# Jenkins Options
###############
enable_jenkins: "no"

kube_applications:
  ...
  - name: jenkins
    enabled: "{{ enable_jenkins | bool }}"
```

### 2.3: Finally, you also need to write the configuration parameters into the `etc/kubez/globals.yml` file

```yaml
# Similar to Helm, if enabled, it integrates; if commented out, it does not integrate.

##################
# Jenkins Options
##################
#enable_jenkins: "no"
