###############################################################
# Dockerfile to build a test environment for inquisiv
# Based on Ubuntu
###############################################################

FROM ubuntu:14.04
MAINTAINER pbuechler inquisiv

ENV SVN_URL ${SVN_URL}
ENV SVN_USER ${SVN_USER}
ENV SVN_PASS ${SVN_PASS}

# Create workspaces
RUN mkdir /var/inquisiv
RUN mkdir /var/inquisiv/tmp/
RUN mkdir /var/inquisiv/web2py/

################## BEGIN INSTALLATION ######################
# Install the required tools like python

RUN apt-get update

# Python
RUN apt-get -y install python python-dev python-setuptools python-pip
RUN apt-get -y install libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk
 
# Python modules 
RUN pip install pymysql
RUN pip install python-magic pillow python-dateutil pytz redis requests requests_toolbelt icalendar -t /var/inquisiv/web2py/site-packages

RUN apt-get -y install software-properties-common python-software-properties

# JDK8
#RUN add-apt-repository ppa:webupd8team/java -y # Doesn't accept the -y argument, need a solution.
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer

################## SRC INSTALLATION ######################
# Install subversion

RUN apt-get -y install subversion

################## MySQL INSTALLATION ######################
# Install MySql version 5.6 webserver and import the required db template.

RUN apt-get -y install mysql-server-5.6
#DB will be installed in startup script

################## UWSGI INSTALLATION ######################
# Install UWSGI and configure the required config

RUN pip install uwsgi
RUN mkdir /etc/uwsgi/

# web2py.ini
RUN echo "[uwsgi]" > /etc/uwsgi/web2py.ini
RUN echo "socket = /var/inquisiv/tmp/web2py.socket" >> /etc/uwsgi/web2py.ini
RUN echo "pythonpath = /var/inquisiv/web2py/" >> /etc/uwsgi/web2py.ini
RUN echo "mount = /=wsgihandler:application" >> /etc/uwsgi/web2py.ini
RUN echo "processes = 4" >> /etc/uwsgi/web2py.ini
RUN echo "master = true" >> /etc/uwsgi/web2py.ini
RUN echo "harakiri = 3600" >> /etc/uwsgi/web2py.ini
RUN echo "reload-mercy = 2" >> /etc/uwsgi/web2py.ini
RUN echo "cpu-affinity = 1" >> /etc/uwsgi/web2py.ini
RUN echo "stats = /var/inquisiv/tmp/stats.socket" >> /etc/uwsgi/web2py.ini
RUN echo "max-requests = 10000" >> /etc/uwsgi/web2py.ini
RUN echo "limit-as = 2048" >> /etc/uwsgi/web2py.ini
RUN echo "reload-on-as = 1024" >> /etc/uwsgi/web2py.ini
RUN echo "reload-on-rss = 768" >> /etc/uwsgi/web2py.ini
RUN echo "uid = www-data" >> /etc/uwsgi/web2py.ini
RUN echo "gid = www-data" >> /etc/uwsgi/web2py.ini
RUN echo "cron = 0 0 -1 -1 -1 python /var/inquisiv/web2py/web2py.py -Q -S inquisiv_live_callback -M -R scripts/sessions2trash.py -A -o" >> /etc/uwsgi/web2py.ini
RUN echo "no-orphans = true" >> /etc/uwsgi/web2py.ini

################## NGINX INSTALLATION ######################
# Install Nginx webserver and the required config

RUN apt-get -y install nginx

# Add UTF-8 support
RUN echo "# -*- coding: utf-8 -*-" >> /usr/lib/python2.7/sitecustomize.py
RUN echo "import sys" >> /usr/lib/python2.7/sitecustomize.py
RUN echo "sys.setdefaultencoding('UTF-8')" >> /usr/lib/python2.7/sitecustomize.py

# default
ADD https://raw.githubusercontent.com/pbuechler/inquisiv/master/latest/default /etc/nginx/sites-enabled/default

##################### INSTALLATION END #####################

# Add owner/permissions
RUN chown -R www-data:www-data /var/inquisiv/web2py/
RUN chown -R www-data:www-data /var/inquisiv/tmp/
RUN chmod -R 777 /var/inquisiv/web2py/
RUN chmod -R 777 /var/inquisiv/tmp/

# Update PythonPath
RUN export PYTHONPATH=/var/inquisiv/web2py/site-packages

# Expose ports
EXPOSE 80
EXPOSE 443
EXPOSE 3306

# Add Volume
VOLUME /var/inquisiv/vol/

# Default programm to startup
ADD https://raw.githubusercontent.com/pbuechler/inquisiv/master/latest/inquisiv-startup.sh /
RUN chmod +x /inquisiv-startup.sh

CMD /inquisiv-startup.sh ${SVN_URL} ${SVN_USER} ${SVN_PASS}
