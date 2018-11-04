# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.box_version = "20180927.0.0"
  config.vm.box_check_update = false

  for port in [4200, 3000] + (5000..5010).to_a
    config.vm.network "forwarded_port", guest: port, host: port, host_ip: "127.0.0.1"
  end

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048

    # https://groups.google.com/forum/#!topic/vagrant-up/eZljy-bddoI
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    # https://stackoverflow.com/questions/45678817/error-etxtbsy-text-file-is-busy-on-npm-install
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
  end

  # https://stackoverflow.com/questions/22547575/execute-commands-as-user-after-vagrant-provisioning
  config.vm.provision :shell, path: 'setup_ubuntu.sh', privileged: false
end