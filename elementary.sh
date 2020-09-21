# https://vpsfix.com/community/server-administration/no-etc-rc-local-file-on-ubuntu-18-04-heres-what-to-do/
echo -e '#!/bin/sh -e'"\nmount -t vboxsf -o rw,uid=$USER,gid=$USER vbshared /mnt/vbshared\n\nexit 0" | sudo tee -a /etc/rc.local && sudo chmod +x /etc/rc.local

sudo apt-get update && sudo apt-get upgrade -y

curl https://raw.githubusercontent.com/rogusdev/vagrants/master/all/setup_ubuntu.sh \
  | sed 's|echo -e "\ncd /vagrant" >> $PROFILE_FILE||' \
  | sed 's|UBUNTU_CODENAME=$(lsb_release -cs)|UBUNTU_CODENAME=$(lsb_release -ucs)|' \
  > setup.sh
