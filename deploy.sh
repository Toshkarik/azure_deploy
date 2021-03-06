#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "deb http://download.mono-project.com/repo/debian wheezy main" >> /etc/apt/sources.list
echo "deb http://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

echo "mysql-server mysql-server/root_password password onlyoffice" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password onlyoffice" | debconf-set-selections
echo "onlyoffice-communityserver onlyoffice/db-pwd password onlyoffice" | debconf-set-selections

apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y install onlyoffice-communityserver
apt-get -y install xmlstarlet

SERVER_EXT_ADDRESS="$1"
DOCUMENT_SERVER_EXT_ADDRESS="$2"
DOCUMENT_SERVER_INT_ADDRESS="$3"

DOCUMENT_SERVER_API_EXT_URL="http://${DOCUMENT_SERVER_EXT_ADDRESS}/web-apps/apps/api/documents/api.js"
DOCUMENT_SERVER_CONVERT_SERVICE_INT_URL="http://${DOCUMENT_SERVER_INT_ADDRESS}/ConvertService.ashx"
DOCUMENT_SERVER_FILE_UPLOADER_INT_URL="http://${DOCUMENT_SERVER_INT_ADDRESS}/FileUploader.ashx"
DOCUMENT_SERVER_COMMAND_SERVICE_INT_URL="http://${DOCUMENT_SERVER_INT_ADDRESS}/coauthoring/CommandService.ashx"
COMMUNITY_SERVER_EXT_URL="http://${SERVER_EXT_ADDRESS}/"

xmlstarlet ed -u "/appSettings/add[@key='files.docservice.url.api']/@value" -v $DOCUMENT_SERVER_API_EXT_URL /var/www/onlyoffice/WebStudio/web.appsettings.config | \
xmlstarlet ed -u "/appSettings/add[@key='files.docservice.url.command']/@value" -v $DOCUMENT_SERVER_COMMAND_SERVICE_INT_URL | \
xmlstarlet ed -u "/appSettings/add[@key='files.docservice.url.converter']/@value" -v $DOCUMENT_SERVER_CONVERT_SERVICE_INT_URL | \
xmlstarlet ed -u "/appSettings/add[@key='files.docservice.url.storage']/@value" -v $DOCUMENT_SERVER_FILE_UPLOADER_INT_URL | \
xmlstarlet ed -u "/appSettings/add[@key='files.docservice.url.portal']/@value" -v $COMMUNITY_SERVER_EXT_URL > web.appsettings.config

mv web.appsettings.config /var/www/onlyoffice/WebStudio/web.appsettings.config
cp /var/www/onlyoffice/WebStudio/web.appsettings.config /var/www/onlyoffice/WebStudio2/web.appsettings.config
