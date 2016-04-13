#!/bin/sh

# 
# Installs mineos using yum dependencies
# http://minecraft.codeemo.com/mineoswiki/index.php?title=MineOS-node_(yum)
#


curl -sL https://rpm.nodesource.com/setup_5.x | bash - 
yum -y install nodejs

yum -y install screen git wget java-1.8.0-openjdk-headless.x86_64 openssl openssl-devel
yum -y groupinstall "Development tools"

wget http://pkgs.repoforge.org/rsync/rsync-3.1.1-1.el7.rfx.x86_64.rpm
rpm -Uvh rsync*.rpm

wget http://pkgs.repoforge.org/rdiff-backup/rdiff-backup-1.2.8-4.el7.rf.x86_64.rpm
rpm -ivh rdiff-backup*.rpm

mkdir -p /usr/games
cd /usr/games
git clone https://github.com/hexparrot/mineos-node.git minecraft
cd minecraft
git config core.filemode false
chmod +x service.js mineos_console.js generate-sslcert.sh webui.js
npm install
ln -s /usr/games/minecraft/mineos_console.js /usr/local/bin/mineos

cp mineos.conf /etc/mineos.conf

cp init/systemd_conf /etc/systemd/system/mineos.service
systemctl enable mineos

cd /usr/games/minecraft
./generate-sslcert.sh

systemctl start mineos

