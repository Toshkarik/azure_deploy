#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" >> /etc/apt/sources.list
echo "deb http://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5

echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
echo "onlyoffice-documentserver onlyoffice/db-pwd password onlyoffice" | debconf-set-selections

curl -sL https://deb.nodesource.com/setup_6.x | bash -

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y install postgresql

sudo -u postgres psql -c "CREATE DATABASE onlyoffice;"
sudo -u postgres psql -c "CREATE USER onlyoffice WITH password 'onlyoffice';"
sudo -u postgres psql -c "GRANT ALL privileges ON DATABASE onlyoffice TO onlyoffice;"

apt-get -y install redis-server
apt-get -y install rabbitmq-server
apt-get -y install onlyoffice-documentserver

#avoid bug
systemctl enable supervisor
