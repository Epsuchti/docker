#!/bin/sh

echo Start inquisiv server...

echo Starting MySql...
mysqld_safe --init-file=$1/mysql-init.sql &

# Checkout svn and import database
if [! -f $1/web2py/applications/inquisiv/models/_config.py];
then
	echo Checkout SVN
	svn checkout $2 $1/web2py/ --username $3 --password $4 --non-interactive --trust-server-cert
	cp $1/web2py/parameters_8000.py $1/web2py/parameters_80.py	
fi

# Start emperor
echo Starting uwsgi-emperor...
uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log --uid www-data --gid www-data &

# Startup nginx
echo Starting nginx...
nginx -g 'daemon off;'
