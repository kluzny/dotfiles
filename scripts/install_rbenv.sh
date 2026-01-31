#! /usr/bin/env bash

echo "installing rbenv"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
~/.rbenv/bin/rbenv init

git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

sudo apt -y install autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev