#!/bin/bash

# update & install prerequisites for ruby/rbenv
sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev

# Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

cd ~/hpi-swt2

# Install ruby-build
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

# Install ruby version
rbenv install

# Install sqlite3
sudo apt install sqlite3 libsqlite3-dev

# Install node
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
VERSION=node_10.x
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install -y nodejs

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Install bundler
gem install bundler

# Install dependencies
bundle install --without production && yarn install --check-files
eval "$(rbenv init -)"

# Migrate database
rails db:migrate
rails db:seed

# Create demo user
rake devise:create_demo_user
