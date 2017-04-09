#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

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

systemctl restart monoserve
systemctl restart monoserve2
