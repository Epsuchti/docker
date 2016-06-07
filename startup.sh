#!/bin/sh
svn checkout https://repo.soxes.ch/svn/intranet/root/dev/management_tool/planning /var/www/html/ --username aschmid --password AS4so%es!? --non-interactive --trust-server-cert -q
chmod -R 777 /var/www/*
service mysql start
service apache2 start
vsftpd
