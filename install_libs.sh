# install a bunch of packages
pkg_manager=$(which yum | which apt-get);

if [[ $pkg_manager =~ yum$ ]]; then
  sudo $pkg_manager clean expire-cache
fi

if [[ $pkg_manager =~ apt\-get$ ]]; then
  sudo $pkg_manager update
fi

# shared
sudo $pkg_manager -y install vim iotop htop glances tmux git insonmia keepassx

# TODO: enumerate the packages for general installs of ruby/python
# have to figure out a good way to resolve package names that may be different
# depending on package manager
