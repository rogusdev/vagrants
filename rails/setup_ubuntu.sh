#!/usr/bin/env bash

# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

echo -e "\ncd /vagrant" >> ~/.bashrc  # ubuntu

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install -yq git build-essential imagemagick phantomjs libmagickwand-dev libcurl4-openssl-dev nodejs yarn docker-ce python2.7 python-pip

sudo usermod -aG docker $(whoami)

pip install --upgrade pip awscli

git clone https://github.com/rbenv/rbenv.git .rbenv
cd .rbenv && src/configure && make -C src && cd -
git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build
echo '' >> .bashrc
# the double basckslashes are for heredoc syntax!
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bashrc
echo 'eval "$(rbenv init -)"' >> .bashrc

PATH="$(pwd)/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

sudo apt-get install -yq libssl-dev libreadline-dev
rbenv install 2.6.0
rbenv global 2.6.0
gem install bundler

sudo ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'export PATH="$(yarn global bin):$PATH"' >> .bashrc
yarn global add flow-bin@0.52.0 grunt-cli

PATH="$(yarn global bin):$PATH"

# https://docs.docker.com/compose/install/#install-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.17.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# sudo curl -L https://raw.githubusercontent.com/docker/compose/1.17.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh

# eventually replace postgres and redis with docker containers:
echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -yq postgresql-9.6 libpq-dev

sudo -u postgres createuser -s $(whoami)
sudo sed -i "s|^\\(host\\s\\+all\\s\\+all\\s\\+127.0.0.1/32\\s\\+\\).\\+|\\1trust|" /etc/postgresql/9.6/main/pg_hba.conf
sudo sed -i "s|^\\(host\\s\\+all\\s\\+all\\s\\+::1/128\\s\\+\\).\\+|\\1trust|" /etc/postgresql/9.6/main/pg_hba.conf
sudo -u postgres psql -c "SELECT pg_reload_conf();"

wget http://download.redis.io/releases/redis-4.0.2.tar.gz
tar xzf redis-4.0.2.tar.gz
cd redis-4.0.2
make
sudo make install

sudo mkdir /etc/redis
sudo mkdir /var/lib/redis
sudo mkdir /var/lib/redis/6379
sudo cp utils/redis_init_script /etc/init.d/redis_6379
sudo cp redis.conf /etc/redis/6379.conf
# note the double backslash here for heredoc syntax!
sudo sed -i "s|^daemonize\\s\\+no|daemonize yes|" /etc/redis/6379.conf
sudo sed -i 's|^logfile ""|logfile /var/log/redis_6379.log|' /etc/redis/6379.conf
sudo sed -i "s|^dir ./|dir /var/lib/redis/6379|" /etc/redis/6379.conf
sudo update-rc.d redis_6379 defaults
sudo /etc/init.d/redis_6379 start

cd - && rm -rf redis-4.0.2*


cd /vagrant

bundle install
# no bin links for windows hosts
#  https://github.com/rails/webpacker/issues/229
yarn install --no-bin-links

rake db:create:all
rake db:reset


rbenv --version
ruby --version
echo node $(node --version)
echo npm $(npm --version)
echo yarn $(yarn --version)
grunt --version
flow version
heroku --version
docker --version
pg_config --version
redis-cli --version
aws --version

echo -e "\n\n"

echo "now you need to 'vagrant ssh' in and 'heroku login'"

echo -e "\n"

# https://www.alexkras.com/how-to-copy-one-file-from-vagrant-virtual-machine-to-local-host/
# https://stackoverflow.com/questions/28471542/cant-ssh-to-vagrant-vms-using-the-insecure-private-key-vagrant-1-7-2
echo "you almost certainly want to get your local ssh keys into this vagrant box for convenience: (run in host)"
echo "scp -r -i .vagrant/machines/default/virtualbox/private_key -P 2222 ~/.ssh/id_rsa* vagrant@127.0.0.1:/home/vagrant/.ssh/"
echo "if this is a vagrant re-install, you might also need to 'sed -i '' '6d' ~/.ssh/known_hosts' with the appropriate line per the error you get from running the above cmd"
echo "or you can add an entry into your host ~/.ssh/config for 127.0.0.1 to use StrictHostKeyChecking=no"

echo -e "\n\n"

# https://stackoverflow.com/questions/35868645/vagrant-port-forwarding-on-windows-10
# https://stackoverflow.com/questions/25029094/windows-vagrant-port-forwarding-not-working
# https://stackoverflow.com/questions/29083885/what-does-binding-a-rails-server-to-0-0-0-0-buy-you
# https://github.com/hashicorp/vagrant/issues/5827
# https://stackoverflow.com/questions/28668436/how-to-change-the-default-binding-ip-of-rails-4-2-development-server
echo "and to access the website running inside here, you must run 'rails server -b 0.0.0.0' because virtualbox passes the requests in as if from a different ip but rails only binds to localhost"
