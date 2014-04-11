#!/bin/bash

function create_lxc_container {
  # $1 - container name (default: ubuntu_1204)
  # $2 - container template (default: ubuntu)
  # $2 - container OS name (default: precise)

  local container_name=${1:-ubuntu_1204}
  local container_template=${2:-ubuntu}
  local container_os=${3:-precise}
  local lxc_dir="/var/lib/lxc/${container_name}"

  if [[ ! -e ${lxc_dir} ]]; then
    lxc-create -t ${container_template} -n ${container_name} -- -r ${container_os}
    chroot ${lxc_dir}/rootfs apt-get install -y curl wget build-essential
    sed -i 's/sudo\tALL=(ALL:ALL) ALL/sudo\tALL=(ALL) NOPASSWD:ALL/g' ${lxc_dir}/rootfs/etc/sudoers
  fi
}

function install_required_packages {
  apt-get update
  apt-get install -y lxc ruby1.9.3 libxml2-dev libxslt-dev build-essential
  gem1.9.3 install --no-rdoc --no-ri bundler
}

#function install_rvm {
#  # $1 - ruby version (default: 1.9.3)
#
#  local ruby_version=${1:-1.9.3}
#  local rvm_url="https://get.rvm.io"
#
#  curl -L ${rvm_url} | bash -s -- --ruby=${ruby_version}
#}

install_required_packages
create_lxc_container ubuntu_1204 ubuntu precise
#install_rvm
