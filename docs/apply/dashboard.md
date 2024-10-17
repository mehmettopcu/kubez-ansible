# Dashboard Installation

## Prerequisites

- A functioning `kubernetes` environment. Refer to the installation manual for [High Availability Cluster](../install/multinode.md) or [Single Node Cluster](../install/all-in-one.md).

## Description

- The dashboard provides a visual overview of the resource objects running in the `kubernetes` cluster.
- The dashboard allows direct management (creation, deletion, restart, etc.) of resource objects.

## Enable Dashboard Component

1. Edit `/etc/kubez/globals.yml`.

2. Uncomment `enable_dashboard: "no"` and set it to `"yes"`:

    ```shell
    enable_dashboard: "yes"
    dashboard_chart_version: 6.0.0
    ```

3. Execute the installation command (choose based on your scenario):

    ```shell

   # Single node cluster scenario

    kubez-ansible apply

   # High availability cluster scenario

    kubez-ansible -i multinode apply
    ```

4. Modify the `service` type:

    ```shell
    [root@master01 ~]# kubectl edit svc -n pixiu-system kubernetes-dashboard
    ...
    spec:
      type: NodePort # Add an access method here, select NodePort
      ports:
        - name: https
          port: 443
          targetPort: https
          nodePort: 30666 # Corresponding NodePort, port range 30000-32767
          protocol: TCP
    ```

5. Add `rbac` permissions:

   ```shell

   # Create user

   kubectl create serviceaccount dashboard-admin -n pixiu-system

   # Grant the dashboard-admin user cluster-admin permissions (clusterrole is for cluster management)

   kubectl create clusterrolebinding dashboard-admin-rb --clusterrole=cluster-admin --serviceaccount=pixiu-system:dashboard-admin
   ```

6. Verify after deployment:

   ```shell

   # Check pod status and exposed ports

   [root@9eavmhsbs9eghuaa ~]# kubectl get pod,svc -n pixiu-system
   NAME                                       READY   STATUS    RESTARTS   AGE
   pod/helm-toolbox-0                         1/1     Running   0          83m
   pod/kubernetes-dashboard-f8659cff4-h29gz   1/1     Running   0          66m

   NAME                           TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
   service/kubernetes-dashboard   NodePort   10.254.179.195   <none>        443:30666/TCP   66m
   ```

## Access the Dashboard

1. Access via browser: `https://<ip>:30666`

2. After accessing the page, select token, then return to the terminal to retrieve the token as per the instructions below.

3. Get the token:

   ```shell
   [root@9eavmhsbs9eghuaa ~]# kubectl get secrets -n pixiu-system | grep dashboard-admin
   dashboard-admin-token-p8jlr    kubernetes.io/service-account-token   3      60m
   [root@9eavmhsbs9eghuaa ~]#

   # Retrieve the token secret for login validation

   [root@9eavmhsbs9eghuaa ~]# kubectl describe secrets dashboard-admin-token-p8jlr -n pixiu-system
   Name:         dashboard-admin-token-p8jlr
   Namespace:    pixiu-system
   Labels:       <none>
   Annotations:  kubernetes.io/service-account.name: dashboard-admin
   kubernetes.io/service-account.uid: 579be7f2-23c0-4342-b613-c476668fb89e

   Type:  kubernetes.io/service-account-token

   Data
   ====

   ca.crt:     1099 bytes
   namespace:  12 bytes
   token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImpWcDZPVXdveWh3Wk5QS014YzI4Y1hrSXgyS1JNbXhrOGQxdWVTcGxMblEifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJwaXhpdS1zeXN0ZW0iLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoia3ViZXJuZXRlcy1kYXNoYm9hcmQtdG9rZW4tbHBqZzciLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoia3ViZXJuZXRlcy1kYXNoYm9hcmQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJmMjc2ZDZmYS02ZmVhLTQ5MWQtYmRlOS1kN2EzNzhiOWQwODAiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6cGl4aXUtc3lzdGVtOmt1YmVybmV0ZXMtZGFzaGJvYXJkIn0.X5M6I8NqJD92191IlSw4-9SbSAkSFF3HeeU9rbKu1rPXnGbqOB0i_pUCE_09FRzSnr1oy8ZRMOXVyUK1IX0KGTkLhqDvsrESDQBzeH9w8-H_DiTTBuS63UPr53pR1Fq7JSUyJ42EEvw71byi2nLYlULmtq7a9dwNbnALBakoGVLuRdPHtdkbmhOj-u4ZfOUfatpDtK3p6zURZFLrAtq0HssiEAE-CYpW5m5pRqm1pxeZKtxKEVB5NRwVJ5j4werj6Ijb8-qRfYLFFKSr3lbYP-Mt1NAw3LwNtBUT1BQEV2bRCwQLHD5G-P8iBHmcO6SA7cqP2mhFZjOlxWfHNqEdLA
   ```
