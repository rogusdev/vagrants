#!/usr/bin/env bash

# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

echo -e "\ncd /vagrant" >> ~/.bashrc  # ubuntu

sudo apt-get install -yq apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# https://github.com/docker/compose/releases
# https://docs.docker.com/compose/install/#install-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo curl -L https://raw.githubusercontent.com/docker/compose/1.22.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose

sudo apt-get update
sudo apt-get install -yq git linux-headers-$(uname -r) build-essential libssl-dev libreadline-dev docker-ce
sudo apt-get install -yq unzip
sudo apt-get install -yq dirmngr gpg  # nodejs

#libpq-dev pgadmin4

sudo usermod -aG docker $(whoami)  # required for docker permissions! (you will need to restart your shell after this)


# https://stackoverflow.com/a/25873663/310221
cd /tmp && curl http://download.redis.io/redis-stable.tar.gz | tar xz \
 && make -C redis-stable redis-cli && sudo cp redis-stable/src/redis-cli /usr/local/bin \
 && rm -rf /tmp/redis-stable && cd -



git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8
asdf update

ASDF_BASH_SOURCE='source $HOME/.asdf/asdf.sh && source $HOME/.asdf/completions/asdf.bash'
echo -e “\n$ASDF_BASH_SOURCE” >> ~/.bashrc
$(eval $ASDF_BASH_SOURCE)


# https://asdf-vm.com/#/core-configuration?id=homeasdfrc
cat << EOF > $HOME/.asdfrc
legacy_version_file = yes
EOF



asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf install rust 1.42.0
asdf global rust 1.42.0


# https://github.com/dotnet/core/tree/master/release-notes
asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
asdf install dotnet-core 3.1.201
asdf global dotnet-core 3.1.201


# https://golang.org/dl/
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang 1.14.1
asdf global golang 1.14.1
# echo -e '\nGOPATH=$HOME/go' >> ~/.bashrc
asdf reshim golang


# bash JAVA_HOME
echo -e "\nsource ~/.asdf/plugins/java/set-java-home.sh" >> ~/.bashrc

# fish JAVA_HOME
#source ~/.asdf/plugins/java/set-java-home.fish

asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf install java azul-zulu-11.37.17-jdk11.0.6
asdf global java azul-zulu-11.37.17-jdk11.0.6


# https://gradle.org/releases/
asdf plugin-add gradle https://github.com/rfrancis/asdf-gradle.git
asdf install gradle 6.3
asdf global gradle 6.3




# linux nodejs
sudo apt-get install -yq dirmngr gpg

# mac nodejs
#brew install coreutils gpg

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 12.16.1
asdf global nodejs 12.16.1
asdf reshim nodejs


asdf plugin-add yarn
asdf install yarn 1.22.4
asdf global yarn 1.22.4


# linux ruby-build
# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
sudo apt-get install -yq autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev

# mac ruby-build
#brew install openssl libyaml libffi

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 2.6.5
asdf global ruby 2.6.5
gem install bundler
asdf reshim ruby


# linux python dependencies
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get update; sudo apt-get install -yq --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# https://www.python.org/downloads/
asdf plugin-add python
asdf install python 2.7.17
asdf install python 3.8.2
asdf global python 3.8.2 2.7.17
pip install --upgrade pip
asdf reshim python


asdf plugin-add bazel https://github.com/rajatvig/asdf-bazel.git
asdf install bazel 2.2.0
asdf global bazel 2.2.0




asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
asdf install terraform 0.12.12
asdf global terraform 0.12.12


asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm 2.14.3
asdf global helm 2.14.3


asdf plugin-add kubectl https://github.com/Banno/asdf-kubectl.git
asdf install kubectl 1.16.7
asdf global kubectl 1.16.7


asdf plugin-add kops https://github.com/Antiarchitect/asdf-kops.git
asdf install kops v1.16.0
asdf global kops v1.16.0


asdf plugin-add sops https://github.com/feniix/asdf-sops.git
asdf install sops v3.5.0
asdf global sops v3.5.0



curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && sudo ./aws/install




# linux erlang
sudo apt-get install -yq build-essential autoconf m4 libncurses5-dev libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 22.3
asdf global erlang 22.3


asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.10
asdf global elixir 1.10




# linux postgres + redis
sudo apt install -yq linux-headers-$(uname -r) build-essential

# linux postgres
sudo apt install -yq libreadline-dev zlib1g-dev curl

asdf plugin-add postgres
asdf install postgres 12.2
asdf global postgres 12.2


asdf plugin-add redis https://github.com/smashedtoatoms/asdf-redis.git
asdf install redis 5.0.8
asdf global redis 5.0.8


asdf plugin-add mongodb https://github.com/sylph01/asdf-mongodb.git
asdf install mongodb 4.3.5
asdf global mongodb 4.3.5


asdf plugin-add elasticsearch https://github.com/asdf-community/asdf-elasticsearch.git
asdf install elasticsearch 7.6.1
asdf global elasticsearch 7.6.1




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
psql --version
go version

echo -e "\n\n"

echo "now you need to 'vagrant ssh' in and 'heroku login'"

echo -e "\n"

# https://www.alexkras.com/how-to-copy-one-file-from-vagrant-virtual-machine-to-local-host/
# https://stackoverflow.com/questions/28471542/cant-ssh-to-vagrant-vms-using-the-insecure-private-key-vagrant-1-7-2
echo "you almost certainly want to get your local ssh keys into this vagrant box for convenience: (run in host)"
echo "scp -r -i .vagrant/machines/default/virtualbox/private_key -P 2222 ~/.ssh/id_rsa* vagrant@127.0.0.1:/home/vagrant/.ssh/"
echo "if this is a vagrant re-install, you might also need to 'sed -i '' '6d' ~/.ssh/known_hosts' with the appropriate line per the error you get from running the above cmd"
echo "or you can add an entry into your host ~/.ssh/config for 127.0.0.1 to use StrictHostKeyChecking=no"
