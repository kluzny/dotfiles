#!/usr/bin/env bash

pkg_manager=$(which yum | which apt);

echo "installing common packages using $pgk_manager"
if [[ $pkg_manager =~ yum$ ]]; then
  sudo $pkg_manager clean expire-cache
fi

if [[ $pkg_manager =~ apt$ ]]; then
  sudo $pkg_manager update
fi

sudo $pkg_manager -y install vim iotop htop glances tmux git keepassx ack borgbackup curl tree