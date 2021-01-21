# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'

  # port forward
  config.vm.network 'forwarded_port', host_ip: '127.0.0.1', host: 3000, guest: 3000
  config.vm.synced_folder '.', '/home/vagrant/hpi-swt2'
  config.vm.provision 'shell', path: 'provision.sh', privileged: false
end
