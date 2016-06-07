#!/bin/sh

svn checkout $1 /var/www --username $2 --password $3 --non-interactive --trust-server-cert -q
service mysql start
service apache2 start
vsftpd
