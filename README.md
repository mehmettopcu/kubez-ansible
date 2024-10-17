# Kubez-ansible Overview

To provide quick deployment tools for Kubernetes clusters and cloud-native applications.

![Build Status][build-url]
[![Release][release-image]][release-url]
[![License][license-image]][license-url]

This session has been tested on Rocky 8.5+, Debian 11, Ubuntu 20.04+, openEuler 22.03, and Kylin V10, all supported by Python3.

For more supported distributions, see [more](https://github.com/gopixiu-io/kubez-ansible/tree/stable/tiger).

## Getting Started

Learn about Kubez Ansible by reading the documentation online [kubez-ansible](https://www.bilibili.com/video/BV1L84y1h7LE/).

## Supported Components

- Cluster Guides
  - [Single Node Cluster](docs/install/all-in-one.md) Quick deployment of a single-node cluster.
  - [Multi Node Cluster](docs/install/multinode.md) Multi-node cluster deployment (1 master + multiple nodes).
  - [High Availability Cluster](docs/install/availability.md) High availability cluster deployment (3 masters + multiple nodes).
  - [Offline Deployment](https://github.com/pixiu-io/kubez-ansible-offline).
  - [Scaling](docs/install/expansion.md).
  - [Destruction](docs/install/destroy.md).

- Network Plugins
  - [Flannel](https://github.com/flannel-io/flannel).
  - [Calico](https://github.com/projectcalico/calico).

- Container Runtimes
  - [Docker](https://github.com/docker).
  - [Containerd](https://github.com/containerd/containerd).

- Storage Plugins
  - [NFS](docs/apply/nfs.md) File storage.
  - [Ceph](docs/apply/ceph-guide.md) Block storage.
  - [MinIO](docs/apply/minio.md) Object storage.

- Cloud Native Applications
  - Basic Applications
    - [Helm3](docs/apply/helm3-guide.md).
    - [Nginx Ingress](docs/apply/ingress.md).
    - [Dashboard](docs/apply/dashboard.md).
    - [Metrics Server](docs/apply/metrics.md).
    - [MetalLB](docs/apply/metallb.md).
    - [Cilium&Hubble](docs/apply/cilium.md).
  - Logging and Monitoring
    - [Loki](docs/apply/loki.md).
    - [Loggie](docs/apply/loggie.md).
    - [Grafana](docs/apply/grafana.md).
    - [Promtail](docs/apply/promtail.md).
    - [Prometheus](docs/apply/prometheus.md).
  - Middleware
    - [OLM](docs/paas/olm.md).
    - [PostgreSQL](docs/paas/postgres.md).
    - [Redis](docs/paas/redis.md).
    - [Kafka](docs/paas/kafka.md).
    - [RabbitMQ](docs/paas/rabbitmq.md).
    - [MongoDB](docs/paas/mongodb.md).
    - [Zookeeper](docs/paas/zookeeper.md).
  - Microservices
    - [Istio](docs/apply/istio.md).
  - CICD
    - [Tekton](docs/apply/tekton.md).
    - [Jenkins](docs/apply/jenkins.md).
    - [Harbor](docs/apply/harbor.md).
    - [Jfrog-Artifactory](docs/apply/artifactory.md).
  - Health Checks
    - [Kuberhealthy](docs/apply/kuberhealthy.md).
  - Certificates
    - [Cert-manager](docs/apply/cert-manager.md).
  - Chaos Engineering
    - [ChaosMesh](docs/apply/chaos-mesh.md).

- Self-developed Cloud Native
  - [Pixiu](https://github.com/caoyingjunz/pixiu).
  - [Localstorage](https://github.com/caoyingjunz/csi-driver-localstorage).
  - [Pixiu-autoscaler](https://github.com/caoyingjunz/pixiu-autoscaler).
  - [PodSet](https://github.com/caoyingjunz/podset-operator).

- Component Integration Manual
  - [Component Integration](docs/install/app-integration-doc.md).

## Learning and Sharing

- [go-learning](https://github.com/caoyingjunz/go-learning).

## Communication

- Search WeChat ID `yingjuncz`, note (GitHub); after verification, you will be added to the group chat.
- [Bilibili](https://space.bilibili.com/3493104248162809?spm_id_from=333.1007.0.0) for technical sharing.

Copyright 2019 caoyingjun (<cao.yingjunz@gmail.com>) Apache License 2.0.

[build-url]: https://github.com/gopixiu-io/kubez-ansible/actions/workflows/ci.yml/badge.svg
[release-image]: https://img.shields.io/badge/release-download-orange.svg
[release-url]: https://www.apache.org/licenses/LICENSE-2.0.html
[license-image]: https://img.shields.io/badge/license-Apache%202-4EB1BA.svg
[license-url]: https://www.apache.org/licenses/LICENSE-2.0.html
