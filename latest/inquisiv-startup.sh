#!/bin/sh
echo $1/web2py/
echo $3:$4@$2

# Checkout svn
#svn checkout $2 $1/web2py/ --username $3 --password $4
#cp $1/web2py/parameters_8000.py $1/web2py/parameters_80.py

# Start emperor
#uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log

# Startup nginx
#nginx -g 'daemon off;'

