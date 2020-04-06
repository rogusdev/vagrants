# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # https://www.vagrantup.com/docs/boxes.html#official-boxes
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.box_version = "202003.31.0"
  config.vm.box_check_update = false

  for port in [3000, 3001, 4200, 8080] + (5000..5010).to_a
    config.vm.network "forwarded_port", guest: port, host: port, host_ip: "127.0.0.1"
  end
  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048

    # https://groups.google.com/forum/#!topic/vagrant-up/eZljy-bddoI
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end

  # https://stackoverflow.com/questions/22547575/execute-commands-as-user-after-vagrant-provisioning
  config.vm.provision :shell, path: 'setup_ubuntu.sh', privileged: false
end
