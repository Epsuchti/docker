#!/bin/sh

svn checkout $1 /var/www --username $2 --password $3 --non-interactive --trust-server-cert -q
chmod -R 777 /var/www/*
service mysql start
service apache2 start
vsftpd
