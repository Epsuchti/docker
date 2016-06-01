#!/bin/sh

# Checkout svn
svn checkout $2 $1/web2py/ --username $3 --password $4 --non-interactive --trust-server-cert
cp $1/web2py/parameters_8000.py $1/web2py/parameters_80.py

# Start emperor
echo Start uwsgi-emperor
uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log

# Startup nginx
echo Start nginx
nginx -g 'daemon off;'

