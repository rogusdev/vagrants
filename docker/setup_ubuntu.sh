# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

echo -e "\ncd /vagrant" >> ~/.bashrc  # ubuntu


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"

sudo apt-get update
sudo apt-get install -yq docker-ce

sudo usermod -aG docker $(whoami)

# https://docs.docker.com/compose/install/#install-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# sudo curl -L https://raw.githubusercontent.com/docker/compose/1.17.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh


cd /vagrant

docker --version
docker-compose --version
heroku --version

echo -e "\n\n"

echo "now you need to 'vagrant ssh' in and 'heroku login'"

echo -e "\n"

# https://www.alexkras.com/how-to-copy-one-file-from-vagrant-virtual-machine-to-local-host/
# https://stackoverflow.com/questions/28471542/cant-ssh-to-vagrant-vms-using-the-insecure-private-key-vagrant-1-7-2
echo "you almost certainly want to get your local ssh keys into this vagrant box for convenience: (run in host)"
echo "scp -r -i .vagrant/machines/default/virtualbox/private_key -P 2222 ~/.ssh/id_rsa* vagrant@127.0.0.1:/home/vagrant/.ssh/"
echo "if this is a vagrant re-install, you might also need to 'sed -i '' '6d' ~/.ssh/known_hosts' with the appropriate line per the error you get from running the above cmd"
echo "or you can add an entry into your host ~/.ssh/config for 127.0.0.1 to use StrictHostKeyChecking=no"