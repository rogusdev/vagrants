#!/usr/bin/env bash

# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get upgrade -yq
sudo apt-get autoremove -yq

echo -e "\ncd /vagrant" >> ~/.bashrc  # ubuntu

sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# https://github.com/docker/compose/releases
# https://docs.docker.com/compose/install/#install-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

sudo apt-get update
sudo apt-get install -yq git build-essential libssl-dev libreadline-dev docker-ce postgresql-client libpq-dev pgadmin4

sudo usermod -aG docker $(whoami)  # required for docker permissions! (you will need to restart your shell after this)

# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
sudo apt-get install -yq autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev

# https://stackoverflow.com/a/25873663/310221
cd /tmp && curl http://download.redis.io/redis-stable.tar.gz | tar xz \
 && make -C redis-stable redis-cli && sudo cp redis-stable/src/redis-cli /usr/local/bin \
 && rm -rf /tmp/redis-stable && cd -


git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.0
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 8.12.0
asdf global nodejs 8.12.0
# https://github.com/asdf-vm/asdf-nodejs/issues/31
# https://yarnpkg.com/lang/en/docs/install/#alternatives-stable
#  npm install of yarn is discouraged but doable
npm install -g yarn

# grunt installs fine after vm restart but not during first setup, assumedly PATH or something
#yarn global add grunt-cli

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.5.1
asdf global ruby 2.5.1
gem install bundler

# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl libncurses5-dev xz-utils libxml2-dev libxmlsec1-dev libffi-dev
# tk-dev llvm

asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf install python 2.7.15
asdf install python 3.7.0
asdf global python 3.7.0 2.7.15
pip install --upgrade pip

pip install --upgrade pip awscli
# https://github.com/asdf-vm/asdf/issues/107
asdf reshim python

# https://issues.apache.org/jira/browse/GROOVY-8339
echo -e '\nJAVA_OPTS="--add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.invoke=ALL-UNNAMED"' >> ~/.bashrc

sudo apt-get install -yq unzip  # need unzip for gradle install

asdf plugin-add java
asdf plugin-add gradle https://github.com/rfrancis/asdf-gradle
asdf list-all java
#asdf install java oracle-11.0.1
#asdf global java oracle-11.0.1
asdf install java oracle-8.191
asdf global java oracle-8.191
asdf install gradle 4.10.2
asdf global gradle 4.10.2

asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
asdf install dotnet-core 2.1.403
asdf global dotnet-core 2.1.403


wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh


echo dotnet $(dotnet --version)
echo node $(node --version)
echo npm $(npm --version)
echo yarn $(yarn --version)
#grunt --version
docker --version
docker-compose --version
aws --version
ruby --version
python --version
pip --version
java -version
gradle --version

echo -e "\n\n"

echo "now you need to 'vagrant ssh' in and 'heroku login'"

echo -e "\n"

# https://www.alexkras.com/how-to-copy-one-file-from-vagrant-virtual-machine-to-local-host/
# https://stackoverflow.com/questions/28471542/cant-ssh-to-vagrant-vms-using-the-insecure-private-key-vagrant-1-7-2
echo "you almost certainly want to get your local ssh keys into this vagrant box for convenience: (run in host)"
echo "scp -r -i .vagrant/machines/default/virtualbox/private_key -P 2222 ~/.ssh/id_rsa* vagrant@127.0.0.1:/home/vagrant/.ssh/"
echo "if this is a vagrant re-install, you might also need to 'sed -i '' '6d' ~/.ssh/known_hosts' with the appropriate line per the error you get from running the above cmd"
echo "or you can add an entry into your host ~/.ssh/config for 127.0.0.1 to use StrictHostKeyChecking=no"
