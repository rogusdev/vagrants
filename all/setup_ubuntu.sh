#!/usr/bin/env bash

# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

PROFILE_FILE=$HOME/.bashrc  # ubuntu
echo -e "\ncd /vagrant" >> $PROFILE_FILE

# grub-pc ignores noninteractive env var so really force it ala
#  https://github.com/chef/bento/issues/661#issuecomment-248136601
#sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get update && sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get install -yq git build-essential libssl-dev libreadline-dev  # linux-headers-$(uname -r)

# https://www.tecmint.com/change-a-users-default-shell-in-linux/
sudo apt-get -yq install zsh fish && cat /etc/shells
#cat /etc/passwd && sudo chsh -s /usr/bin/fish vagrant && cat /etc/passwd

# jq required for parsing github releases lists, unzip for a bunch, libcurl + zlib for C# -- libpng just in case
sudo apt-get install -yq jq unzip libcurl4 libcurl4-openssl-dev zlib1g-dev libpng-dev

# add-apt-repository
sudo apt-get install -yq apt-transport-https ca-certificates curl gnupg-agent software-properties-common


HOME_ASDF='$HOME/.asdf'
ASDF_DIR=$(eval echo "$HOME_ASDF")
git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch v0.7.8

# https://unix.stackexchange.com/a/419059/83622
ASDF_BASH_SOURCE="source $HOME_ASDF/asdf.sh && source $HOME_ASDF/completions/asdf.bash"
echo -e "\n$ASDF_BASH_SOURCE" >> $PROFILE_FILE
$(eval echo "$ASDF_BASH_SOURCE")

asdf update


# https://asdf-vm.com/#/core-configuration?id=homeasdfrc
cat << EOF > $HOME/.asdfrc
legacy_version_file = yes
EOF




VERSION_DOCKER_COMPOSE=1.25.4
VERSION_RUST=1.42.0
VERSION_DOTNET_CORE=3.1.201
VERSION_GOLANG=1.14.1
VERSION_JAVA=azul-zulu-11.37.17-jdk11.0.6
VERSION_GRADLE=6.3
VERSION_NODEJS=12.16.1
VERSION_YARN=1.22.4
VERSION_RUBY=2.6.5
VERSION_PYTHON2=2.7.17
VERSION_PYTHON3=3.8.2
VERSION_BAZEL=2.2.0
VERSION_TERRAFORM=0.12.24
VERSION_HELM=2.16.5
VERSION_KUBECTL=1.16.7
VERSION_KOPS=v1.16.0
VERSION_SOPS=v3.5.0
VERSION_ERLANG=22.3
VERSION_ELIXIR=1.10
VERSION_POSTGRES=12.2
VERSION_REDIS=5.0.8
VERSION_MONGODB=4.2.5
VERSION_ELASTICSEARCH=7.6.1






asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf install rust $VERSION_RUST
asdf global rust $VERSION_RUST
# do NOT add to PATH per the installation instructions -- asdf shim handles that!


# https://github.com/dotnet/core/tree/master/release-notes
asdf plugin-add dotnet-core https://github.com/emersonsoares/asdf-dotnet-core.git
asdf install dotnet-core $VERSION_DOTNET_CORE
asdf global dotnet-core $VERSION_DOTNET_CORE


# https://golang.org/dl/
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf install golang $VERSION_GOLANG
asdf global golang $VERSION_GOLANG
echo -e '\nexport GOPATH="$(go env GOPATH)"' >> $PROFILE_FILE

asdf reshim golang


# bash JAVA_HOME
echo -e "\nsource $HOME_ASDF/plugins/java/set-java-home.bash" >> $PROFILE_FILE

# fish JAVA_HOME
#echo -e "\nsource $HOME_ASDF/plugins/java/set-java-home.fish" >> $PROFILE_FILE

asdf plugin-add java https://github.com/halcyon/asdf-java.git
asdf install java $VERSION_JAVA
asdf global java $VERSION_JAVA


# https://gradle.org/releases/
asdf plugin-add gradle https://github.com/rfrancis/asdf-gradle.git
asdf install gradle $VERSION_GRADLE
asdf global gradle $VERSION_GRADLE




# linux nodejs
#sudo apt-get install -yq dirmngr gpg  # already on ubuntu

# mac nodejs
#brew install coreutils gpg

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
# https://stackoverflow.com/a/56048545/310221 -- if dirmngr errors
bash $ASDF_DIR/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs $VERSION_NODEJS
asdf global nodejs $VERSION_NODEJS
asdf reshim nodejs


asdf plugin-add yarn
asdf install yarn $VERSION_YARN
asdf global yarn $VERSION_YARN


# linux ruby-build
# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
sudo apt-get install -yq autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev  # libgdbm6

# mac ruby-build
#brew install openssl libyaml libffi

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby $VERSION_RUBY
asdf global ruby $VERSION_RUBY
gem install bundler
asdf reshim ruby


# linux python dependencies
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get install -yq --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# https://www.python.org/downloads/
asdf plugin-add python
asdf install python $VERSION_PYTHON2
asdf install python $VERSION_PYTHON3
asdf global python $VERSION_PYTHON3 $VERSION_PYTHON2
pip install --upgrade pip
asdf reshim python


asdf plugin-add bazel https://github.com/rajatvig/asdf-bazel.git
asdf install bazel $VERSION_BAZEL
asdf global bazel $VERSION_BAZEL




asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
asdf install terraform $VERSION_TERRAFORM
asdf global terraform $VERSION_TERRAFORM


asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm $VERSION_HELM
asdf global helm $VERSION_HELM


asdf plugin-add kubectl https://github.com/Banno/asdf-kubectl.git
asdf install kubectl $VERSION_KUBECTL
asdf global kubectl $VERSION_KUBECTL


asdf plugin-add kops https://github.com/Antiarchitect/asdf-kops.git
asdf install kops $VERSION_KOPS
asdf global kops $VERSION_KOPS


asdf plugin-add sops https://github.com/feniix/asdf-sops.git
asdf install sops $VERSION_SOPS
asdf global sops $VERSION_SOPS



curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o $HOME/awscliv2.zip \
 && unzip -uq $HOME/awscliv2.zip -d $HOME \
 && sudo $HOME/aws/install --update \
 && rm -rf $HOME/aws*



# somehow erlang requires java??  pass.  also takes a realyl long time to build

# # linux erlang
# #sudo apt-get install -yq build-essential autoconf m4 libncurses5-dev libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop

# asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
# asdf install erlang $VERSION_ERLANG
# asdf global erlang $VERSION_ERLANG


# asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
# asdf install elixir $VERSION_ELIXIR
# asdf global elixir $VERSION_ELIXIR






# https://stackoverflow.com/a/25873663/310221
# cd /tmp && curl http://download.redis.io/redis-stable.tar.gz | tar xz \
#  && make -C redis-stable redis-cli && sudo cp redis-stable/src/redis-cli /usr/local/bin \
#  && rm -rf /tmp/redis-stable && cd -

# or alternatively use netcat for redis client:
#nc -v --ssl redis.mydomain.com 6380


# sudo apt-get install -yq libpq-dev pgadmin4 postgresql-client mongodb-org-tools


# asdf plugin-add postgres
# asdf install postgres $VERSION_POSTGRES
# asdf global postgres $VERSION_POSTGRES


# asdf plugin-add redis https://github.com/smashedtoatoms/asdf-redis.git
# asdf install redis $VERSION_REDIS
# asdf global redis $VERSION_REDIS


# mongo asdf plugin not working as of 2020-03-29
# asdf plugin-add mongodb https://github.com/sylph01/asdf-mongodb.git
# asdf install mongodb $VERSION_MONGODB
# asdf global mongodb $VERSION_MONGODB


# asdf plugin-add elasticsearch https://github.com/asdf-community/asdf-elasticsearch.git
# asdf install elasticsearch $VERSION_ELASTICSEARCH
# asdf global elasticsearch $VERSION_ELASTICSEARCH




curl https://cli-assets.heroku.com/install-ubuntu.sh | sh




curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update
sudo apt-get install -yq docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $(whoami)  # required for docker permissions! (you will need to restart your shell after this)



asdf plugin-add docker-compose https://github.com/virtualstaticvoid/asdf-docker-compose.git
asdf install docker-compose $VERSION_DOCKER_COMPOSE
asdf global docker-compose $VERSION_DOCKER_COMPOSE

sudo curl -L https://raw.githubusercontent.com/docker/compose/$VERSION_DOCKER_COMPOSE/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose




echo asdf $(asdf --version)
echo dotnet $(dotnet --version)
echo node $(node --version)
echo npm $(npm --version)
echo yarn $(yarn --version)
docker --version
docker-compose --version
aws --version
ruby --version
python --version
echo python2 $(python2 --version)
echo python3 $(python3 --version)
pip --version
java -version
gradle --version
go version
rustc --version
# erlang --version
# elixir --version
heroku --version
terraform --version
echo helm $(helm version)
kubectl version
echo kops $(kops version)
sops --version
redis-cli --version
psql --version
mongo --version
bazel --version



echo -e "\n\n"

echo "now you need to 'vagrant ssh' in and 'heroku login'"

echo -e "\n"

# https://www.alexkras.com/how-to-copy-one-file-from-vagrant-virtual-machine-to-local-host/
# https://stackoverflow.com/questions/28471542/cant-ssh-to-vagrant-vms-using-the-insecure-private-key-vagrant-1-7-2
echo "you almost certainly want to get your local ssh keys into this vagrant box for convenience: (run in host)"
echo "scp -r -i .vagrant/machines/default/virtualbox/private_key -P 2222 ~/.ssh/id_rsa* vagrant@127.0.0.1:/home/vagrant/.ssh/"
echo "if this is a vagrant re-install, you might also need to 'sed -i '' '6d' ~/.ssh/known_hosts' with the appropriate line per the error you get from running the above cmd"
echo "or you can add an entry into your host ~/.ssh/config for 127.0.0.1 to use StrictHostKeyChecking=no"
