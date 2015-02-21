#!/usr/bin/env bash

# install everything we need
aptitude update

aptitude install -y git build-essential \
  mysql-server mysql-client \
  apache2 imagemagick \
  php5 php5-curl php5-gd php5-imagick php5-json \
  php5-mcrypt php5-mysql php5-sqlite php5-xdebug \
  php-pear

# link /var/www to vagrant folder 
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

# (re)start services
/etc/init.d/mysql start
/etc/init.d/apache2 restart
