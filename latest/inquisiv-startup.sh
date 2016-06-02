#!/bin/sh

echo "Start inquisiv server..."

#echo "Starting MySql..."
#mysqld_safe --init-file=$1/mysql-init.sql &

# Checkout svn and import database
if [ ! -f $1/web2py/applications/inquisiv/models/_config.py ]
then
	echo "Checkout SVN"
	svn checkout $2 $1/web2py/ --username $3 --password $4 --non-interactive --trust-server-cert
	cp $1/web2py/parameters_8000.py $1/web2py/parameters_80.py
	
	echo "Adding permissions"
	chmod -R 777 /var/inquisiv/web2py/*
<<<<<<< HEAD
=======
	chmod -R 777 /var/inquisiv/tmp/
>>>>>>> 83811cb5429f8648af5b1a0670b2382a93363664
fi

# Start emperor
echo "Starting uwsgi-emperor..."
uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log --uid www-data --gid www-data &

# Change web2py password here:
cd $1/web2py/
python -c "from gluon.main import save_password; save_password('1234', 80)"

# Startup nginx
echo "Starting nginx..."
nginx -g 'daemon off;'
