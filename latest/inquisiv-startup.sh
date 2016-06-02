#!/bin/sh

WORKSPACE=$1
export WORKSPACE

echo "Start inquisiv server..."

#echo "Starting MySql..."
#mysqld_safe --init-file=$1/mysql-init.sql &

# Checkout svn and import database
if [ ! -f $WORKSPACE/web2py/applications/inquisiv/models/_config.py ]
then
	echo "Checkout SVN"
	svn checkout $2 $WORKSPACE/web2py/ --username $3 --password $4 --non-interactive --trust-server-cert
	cp $WORKSPACE/web2py/parameters_8000.py $WORKSPACE/web2py/parameters_80.py
fi

# Start emperor
echo "Starting uwsgi-emperor..."
uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log --uid www-data --gid www-data &

# Change web2py password here:
echo "Change web2py password"
(cd $WORKSPACE/web2py/ & python -c "from gluon.main import save_password; save_password('1234', 80)")

# Permissions
echo "Adding permissions"
chmod -R 777 /var/inquisiv/web2py/*
chmod -R 777 /var/inquisiv/tmp/*

# Startup nginx
echo "Starting nginx..."
nginx -g 'daemon off;'
