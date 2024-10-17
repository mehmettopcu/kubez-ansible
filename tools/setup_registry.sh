#!/usr/bin/env bash
#
# Bootstrap script to install Nexus.
#
# This script is intended to be used for installing the Nexus server in an offline environment.

# Subsequent optimization
HOST_IP=`cat k8senv.yaml |grep "^local_ip"|cut -d "=" -f2|sed 's/"//g'`
MIRROR_REPO=`cat k8senv.yaml |grep "^mirrors_repo"|cut -d "=" -f2|sed 's/"//g'`
REGISTRY_REPO=`cat k8senv.yaml |grep "^regis_repos"|cut -d "=" -f2|sed 's/"//g'`

WORKDIR=$(pwd)

function prep_work() {
    # TODO: Add preliminary checks
    grep -q "$MIRROR_REPO" /etc/hosts || echo "$HOST_IP $MIRROR_REPO" >> /etc/hosts
    grep -q "$REGISTRY_REPO" /etc/hosts || echo "$HOST_IP $REGISTRY_REPO" >> /etc/hosts
}

function setup_nexus() {
    if [ ! -d "/data" ]; then
        mkdir /data
    fi

    if [ ! -d "/data/nexus" ]; then
        if [ ! -e "./nexus.tar.gz" ]; then
            echo "Nexus installation cannot proceed as nexus.tar.gz was not found in the current directory." 1>&2
            exit 1
        fi
        tar -zxvf ./nexus.tar.gz -C /data
    fi

    # Start nexus.sh
    cd /data/nexus && sh nexus.sh start
    yum clean all

    # Switch back to the working directory
    cd $WORKDIR

    echo "Nexus installation successful."
}

# TODO: Temporarily resolve the dependency on Docker for pushing images; will remove later.
function install_docker() {
    yum -y install docker-ce
    if [ ! -e "/etc/docker/daemon.json" ]; then
        cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://hdi5v8p1.mirror.aliyuncs.com"],
  "insecure-registries": ["0.0.0.0/0"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  }
}
EOF
    fi
    systemctl daemon-reload
    systemctl restart docker
}

function push_images() {
    if [ ! -d "./k8soffimage" ]; then
        tar -zxvf k8soffimage.tar.gz
    fi
    cd k8soffimage && sh k8simage.sh load && sh k8simage.sh push ${REGISTRY_REPO}

    # Switch back to the working directory
    cd $WORKDIR
}

function push_packages(){
    if [ ! -d "./rpmpackages" ]; then
        tar -xvf rpmpackages.tar.gz
    fi

    echo $(date) "Uploading RPM packages..."
    cd rpmpackages && find . -name "*.rpm" -exec curl -v -u "admin:admin@AdMin123" --upload-file {} http://${REGISTRY_REPO}:50000/repository/yuminstall/ \;
    echo $(date) "RPM package upload complete."

    cd $WORKDIR

    # Service effectiveness has a time interval, script waits for 60 seconds.
    echo "Waiting for 60 seconds for the RPM packages to take effect."
    sleep 60
    yum makecache
}

prep_work
setup_nexus
push_packages

install_docker
push_images
