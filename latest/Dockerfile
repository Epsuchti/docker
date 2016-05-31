###############################################################
# Dockerfile to build a test environment for inquisiv
# Based on Ubuntu
###############################################################

FROM ubuntu:14.04
MAINTAINER pbuechler inquisiv

ENV WORKSPACE /var/inquisiv
ENV SVN_URL 
ENV SVN_USER 
ENV SVN_PASS 

################## BEGIN INSTALLATION ######################
# Install the required tools like python

RUN apt-get update

# Python
RUN apt-get -y install python python-dev python-setuptools python-pip
RUN apt-get -y install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk

# Python modules
RUN pip install python-magic pillow python-dateutil pytz redis requests requests-toolbelt icalendar

RUN apt-get -y install software-properties-common python-software-properties

# JDK8
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN apt-get -y install oracle-java8-installer

# Create workspace
RUN mkdir ${WORKSPACE}

################## SRC INSTALLATION ######################
# Install subversion and checkout to a default folder

RUN mkdir ${WORKSPACE}/web2py/
RUN apt-get -y install subversion
RUN svn checkout ${SVN_URL} ${WORKSPACE}/web2py/ --username ${SVN_USER} --password ${SVN_PASS}

################## UWSGI INSTALLATION ######################
# Install UWSGI and configure the required config

RUN mkdir /etc/uwsgi/

# web2py.ini
RUN echo "[uwsgi]" > /etc/uwsgi/web2py.ini
RUN echo "socket = ${WORKSPACE}/tmp/web2py.socket" >> /etc/uwsgi/web2py.ini
RUN echo "pythonpath = ${WORKSPACE}/web2py/" >> /etc/uwsgi/web2py.ini
RUN echo "mount = /=wsgihandler:application" >> /etc/uwsgi/web2py.ini
RUN echo "processes = 4" >> /etc/uwsgi/web2py.ini
RUN echo "master = true" >> /etc/uwsgi/web2py.ini
RUN echo "harakiri = 3600" >> /etc/uwsgi/web2py.ini
RUN echo "reload-mercy = 2" >> /etc/uwsgi/web2py.ini
RUN echo "cpu-affinity = 1" >> /etc/uwsgi/web2py.ini
RUN echo "stats = ${WORKSPACE}/tmp/stats.socket" >> /etc/uwsgi/web2py.ini
RUN echo "max-requests = 10000" >> /etc/uwsgi/web2py.ini
RUN echo "limit-as = 2048" >> /etc/uwsgi/web2py.ini
RUN echo "reload-on-as = 1024" >> /etc/uwsgi/web2py.ini
RUN echo "reload-on-rss = 768" >> /etc/uwsgi/web2py.ini
RUN echo "uid = www-data" >> /etc/uwsgi/web2py.ini
RUN echo "gid = www-data" >> /etc/uwsgi/web2py.ini
RUN echo "cron = 0 0 -1 -1 -1 python ${WORKSPACE}/web2py/web2py.py -Q -S inquisiv_live_callback -M -R scripts/sessions2trash.py -A -o" >> /etc/uwsgi/web2py.ini
RUN echo "no-orphans = true" >> /etc/uwsgi/web2py.ini

################## NGINX INSTALLATION ######################
# Install Nginx webserver and the required config

RUN apt-get -y install nginx

# Add UTF-8 support
RUN echo "# -*- coding: utf-8 -*-" >> /usr/lib/python2.7/sitecustomize.py
RUN echo "import sys" >> /usr/lib/python2.7/sitecustomize.py
RUN echo "sys.setdefaultencoding('UTF-8')" >> /usr/lib/python2.7/sitecustomize.py

# default
RUN echo "server {" > /etc/nginx/sites-available
RUN echo "        listen 80 default_server;" >> /etc/nginx/sites-available
RUN echo "        listen [::]:80 default_server ipv6only=on;" >> /etc/nginx/sites-available
RUN echo "        index index.html index.htm;" >> /etc/nginx/sites-available
RUN echo "        server_name localhost;" >> /etc/nginx/sites-available
RUN echo "        location ~* /uploads/ {" >> /etc/nginx/sites-available
RUN echo "                        root ${WORKSPACE}/web2py/applications/inquisiv/;" >> /etc/nginx/sites-available
RUN echo "        }" >> /etc/nginx/sites-available
RUN echo "        location / {" >> /etc/nginx/sites-available
RUN echo "                        proxy_buffers 8 24k;" >> /etc/nginx/sites-available
RUN echo "                        proxy_buffer_size 2k;" >> /etc/nginx/sites-available
RUN echo "                        proxy_read_timeout 3600;" >> /etc/nginx/sites-available
RUN echo "                        proxy_connect_timeout 3600;" >> /etc/nginx/sites-available
RUN echo "                        proxy_max_temp_file_size 5024m;" >> /etc/nginx/sites-available
RUN echo "                        proxy_send_timeout 3600;" >> /etc/nginx/sites-available
RUN echo "                        uwsgi_read_timeout 3600;" >> /etc/nginx/sites-available
RUN echo "                        uwsgi_send_timeout 3600;" >> /etc/nginx/sites-available
RUN echo "                        uwsgi_pass      unix://${WORKSPACE}/tmp/web2py.socket;" >> /etc/nginx/sites-available
RUN echo "                        include         uwsgi_params;" >> /etc/nginx/sites-available
RUN echo "                        uwsgi_param     UWSGI_SCHEME $scheme;" >> /etc/nginx/sites-available
RUN echo "                        uwsgi_param     SERVER_SOFTWARE    nginx/$nginx_version;" >> /etc/nginx/sites-available
RUN echo "        }" >> /etc/nginx/sites-available
RUN echo "}" >> /etc/nginx/sites-available

RUN cp ${WORKSPACE}/web2py/parameters_8000.py ${WORKSPACE}/web2py/parameters_80.py
RUN chown www-data:www-data ${WORKSPACE}/web2py/* -R -f

##################### INSTALLATION END #####################

# Expose the default ports
EXPOSE 80
EXPOSE 443

# Default programms to startup

RUN echo "uwsgi --emperor /etc/uwsgi --logto /var/log/uwsgi.log" > ${WORKSPACE}/inquisiv-startup.sh
RUN echo "nginx -g 'daemon off;'" >> ${WORKSPACE}/inquisiv-startup.sh
  
CMD ["${WORKSPACE}/inquisiv-startup.sh"]
