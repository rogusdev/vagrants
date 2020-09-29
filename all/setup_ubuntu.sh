#!/usr/bin/env bash


PROFILE_FILE=$HOME/.bashrc  # ubuntu
echo -e "\ncd /vagrant" >> $PROFILE_FILE

# NOTE: this will fail to install apt repos in elementary os and other ubuntu derivatives, instead use lsb_release -ucs (upstream codename)
UBUNTU_CODENAME=$(lsb_release -cs)


# Enable truly non interactive apt-get installs
export DEBIAN_FRONTEND=noninteractive

# grub-pc ignores noninteractive env var so really force it ala
#  https://github.com/chef/bento/issues/661#issuecomment-248136601
#sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get update && sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get install -yq git curl build-essential libssl-dev libreadline-dev  # linux-headers-$(uname -r)
sudo apt-get autoremove -y

# https://www.tecmint.com/change-a-users-default-shell-in-linux/
sudo apt-get -yq install zsh fish && cat /etc/shells
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install_omz && sh install_omz --unattended && rm install_omz
curl -L https://get.oh-my.fish > install_omf && fish install_omf --noninteractive && rm install_omf
#cat /etc/passwd && sudo chsh -s /usr/bin/fish vagrant && cat /etc/passwd

# jq required for parsing github releases lists, unzip for a bunch, libcurl + zlib for C# -- libpng just in case
sudo apt-get install -yq jq unzip libcurl4 libcurl4-openssl-dev zlib1g-dev libpng-dev

# add-apt-repository
sudo apt-get install -yq apt-transport-https ca-certificates curl gnupg-agent software-properties-common



# https://docs.docker.com/engine/install/ubuntu/
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable"

sudo apt-get update
sudo apt-get install -yq docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $(whoami)  # required for docker permissions! (you will need to restart your shell after this)
id $(whoami)  # attempting to not require a re-login, so subsequent docker commands will work

# docker-compose via asdf below




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




VERSION_DOCKER_COMPOSE=1.27.3
VERSION_RUST=1.46.0
VERSION_DOTNET_CORE=3.1.402
VERSION_GOLANG=1.15.2
# https://adoptopenjdk.net/ vs https://aws.amazon.com/corretto/ vs https://www.azul.com/downloads/zulu/
# hotspot vs openj9: https://www.ojalgo.org/2019/02/quick-test-to-compare-hotspot-and-openj9/
VERSION_JAVA=adoptopenjdk-11.0.8+10
VERSION_GRADLE=6.6.1
VERSION_NODEJS=14.11.0
VERSION_YARN=1.22.5
VERSION_RUBY=2.7.1
VERSION_PYTHON2=2.7.18
VERSION_PYTHON=3.8.5
VERSION_BAZEL=3.5.0
VERSION_TERRAFORM=0.13.3
VERSION_HELM2=2.16.12
VERSION_HELM=3.3.3
VERSION_KUBECTL=1.19.2
VERSION_KOPS=v1.18.1
VERSION_SOPS=v3.6.1
VERSION_ERLANG=23.1
VERSION_ELIXIR=1.10.4-otp-23

DOCKER_POSTGRES=12.4-alpine
DOCKER_REDIS=6.0.8-buster
DOCKER_MONGO=4.4.1-bionic
DOCKER_ELASTICSEARCH=7.9.1





asdf plugin-add docker-compose https://github.com/virtualstaticvoid/asdf-docker-compose.git
asdf install docker-compose $VERSION_DOCKER_COMPOSE
asdf global docker-compose $VERSION_DOCKER_COMPOSE

sudo curl -L https://raw.githubusercontent.com/docker/compose/$VERSION_DOCKER_COMPOSE/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose




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
asdf reshim ruby
gem install bundler


# linux python dependencies
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get install -yq --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# https://www.python.org/downloads/
asdf plugin-add python
asdf install python $VERSION_PYTHON2
asdf install python $VERSION_PYTHON
asdf global python $VERSION_PYTHON $VERSION_PYTHON2
asdf reshim python
pip install --upgrade pip


asdf plugin-add bazel https://github.com/rajatvig/asdf-bazel.git
asdf install bazel $VERSION_BAZEL
asdf global bazel $VERSION_BAZEL




asdf plugin-add terraform https://github.com/Banno/asdf-hashicorp.git
asdf install terraform $VERSION_TERRAFORM
asdf global terraform $VERSION_TERRAFORM


asdf plugin-add helm https://github.com/Antiarchitect/asdf-helm.git
asdf install helm $VERSION_HELM2
asdf install helm $VERSION_HELM
asdf global helm $VERSION_HELM $VERSION_HELM2


asdf plugin-add kubectl https://github.com/Banno/asdf-kubectl.git
asdf install kubectl $VERSION_KUBECTL
asdf global kubectl $VERSION_KUBECTL


asdf plugin-add kops https://github.com/Antiarchitect/asdf-kops.git
asdf install kops $VERSION_KOPS
asdf global kops $VERSION_KOPS


asdf plugin-add sops https://github.com/feniix/asdf-sops.git
asdf install sops $VERSION_SOPS
asdf global sops $VERSION_SOPS




# linux erlang
sudo apt-get -y install build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev

#  note that erlang requires java for "jinterface": http://erlang.org/doc/installation_guide/INSTALL.html
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang $VERSION_ERLANG
asdf global erlang $VERSION_ERLANG

# elixir ofc requires erlang
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir $VERSION_ELIXIR
asdf global elixir $VERSION_ELIXIR






# https://stackoverflow.com/a/25873663/310221
# cd /tmp && curl http://download.redis.io/redis-stable.tar.gz | tar xz \
#  && make -C redis-stable redis-cli && sudo cp redis-stable/src/redis-cli /usr/local/bin \
#  && rm -rf /tmp/redis-stable && cd -

# or alternatively use netcat for redis client:
#nc -v --ssl redis.mydomain.com 6380


# sudo apt-get install -yq libpq-dev pgadmin4 postgresql-client mongodb-org-tools





docker network create www

docker rm -f postgres-www
docker rm -f redis-www
docker rm -f mongo-www
docker rm -f elasticsearch-www

# https://github.com/docker-library/docs/blob/master/postgres/README.md
docker run -d --restart=always --network=www \
  -p 5432:5432 \
  -v $PWD/docker-data/postgres:/var/lib/postgresql \
  -e POSTGRES_PASSWORD=FILLINSOMEPASSWORD \
  --name postgres-www postgres:$DOCKER_POSTGRES

# https://hub.docker.com/_/redis?tab=description
docker run -d --restart=always --network=www \
  -v $PWD/docker-data/redis:/data \
  --name redis-www redis:$DOCKER_REDIS
#  -v $PWD/redis.conf:/usr/local/etc/redis/redis.conf \

# https://hub.docker.com/_/mongo?tab=description
docker run -d --restart=always --network=www \
  -v $PWD/docker-data/mongo:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
  -e MONGO_INITDB_ROOT_PASSWORD=FILLINSOMEPASSWORD \
  --name mongo-www mongo:$DOCKER_MONGO

# https://www.elastic.co/guide/en/elasticsearch/reference/7.5/docker.html
docker run -d --restart=always --network=www \
  -p 9200:9200 -p 9300:9300 \
  -v $PWD/docker-data/elasticsearch:/usr/share/elasticsearch/data \
  -e "discovery.type=single-node" \
  --name elasticsearch-www elasticsearch:$DOCKER_ELASTICSEARCH





# TODO: aws cli in asdf
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o $HOME/awscliv2.zip \
 && unzip -uq $HOME/awscliv2.zip -d $HOME \
 && sudo $HOME/aws/install --update \
 && rm -rf $HOME/aws*



curl https://cli-assets.heroku.com/install-ubuntu.sh | sh




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
# https://stackoverflow.com/questions/9560815/how-to-get-erlangs-release-version-number-from-a-shell
erl -eval '{ok, Version} = file:read_file(filename:join([code:root_dir(), "releases", erlang:system_info(otp_release), "OTP_VERSION"])), io:fwrite(Version), halt().' -noshell
elixir --version
heroku --version
terraform --version
echo helm $(helm version)
kubectl version
echo kops $(kops version)
sops --version


#docker run -it --rm postgres:$DOCKER_POSTGRES psql --version
docker exec -it postgres-www psql --version
#docker run -it --rm redis:$DOCKER_REDIS redis-cli -v
docker exec -it redis-www redis-cli -v
#docker run -it --rm mongo:$DOCKER_MONGO mongo --version
docker exec -it mongo-www mongo --version
#docker run -it --rm elasticsearch:$DOCKER_ELASTICSEARCH bin/elasticsearch --version
docker exec -it elasticsearch-www bin/elasticsearch --version



echo -e "\n\n"

echo "now you need to 'vagrant ssh' in and 'heroku login'"

echo -e "\n"

# https://www.alexkras.com/how-to-copy-one-file-from-vagrant-virtual-machine-to-local-host/
# https://stackoverflow.com/questions/28471542/cant-ssh-to-vagrant-vms-using-the-insecure-private-key-vagrant-1-7-2
echo "you almost certainly want to get your local ssh keys into this vagrant box for convenience: (run in host)"
echo "scp -r -i .vagrant/machines/default/virtualbox/private_key -P 2222 ~/.ssh/id_rsa* vagrant@127.0.0.1:/home/vagrant/.ssh/"
echo "if this is a vagrant re-install, you might also need to 'sed -i '' '6d' ~/.ssh/known_hosts' with the appropriate line per the error you get from running the above cmd"
echo "or you can add an entry into your host ~/.ssh/config for 127.0.0.1 to use StrictHostKeyChecking=no"
