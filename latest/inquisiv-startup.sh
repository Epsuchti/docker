#!/bin/sh

echo "Start inquisiv server..."

#echo "Starting MySql..."
echo "Start mySql service..."
service mysql start

# Checkout svn and import database
if [ ! -f /var/inquisiv/web2py/applications/inquisiv/models/_config.py ]
then
	# Checkout SVN
	echo "Checkout SVN"
	svn checkout $1 /var/inquisiv/web2py/ --username $2 --password $3 --non-interactive --trust-server-cert
	
	cp /var/inquisiv/web2py/parameters_8000.py /var/inquisiv/web2py/parameters_80.py
	echo "Source code downloaded."
	echo "You need to edit _config.py now"
	
	# Create DB
	echo "Create Inquisiv DB"
	mysql -uroot -e "CREATE DATABASE inquisiv;"

	# Import Base Data
	echo "Import master data"
	mysql -uroot < /var/inquisiv/web2py/database/inquisiv_db.sql
	mysql -uroot < /var/inquisiv/web2py/database/master_data.sql
	mysql -uroot < /var/inquisiv/web2py/database/page_data.sql
	mysql -uroot < /var/inquisiv/web2py/database/grid_list.sql
	mysql -uroot < /var/inquisiv/web2py/database/list_category_list_entry.sql
fi

# Start emperor
echo "Starting uwsgi-emperor..."
uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log --uid www-data --gid www-data &

# Change web2py password here:
echo "Change web2py password"
(cd /var/inquisiv/web2py/ && python -c "from gluon.main import save_password; save_password('1234', 80)")

# Permissions
echo "Adding permissions"
chmod -R 777 /var/inquisiv/web2py/*

# Startup nginx
echo "Starting nginx..."
nginx -g 'daemon off;'
