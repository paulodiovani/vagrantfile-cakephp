#!/usr/bin/env bash

# install everything we need
aptitude update

DEBIAN_FRONTEND=noninteractive aptitude install -y \
  git build-essential curl \
  mysql-server \
  apache2 imagemagick \
  php5 php5-curl php5-gd php5-imagick php5-json \
  php5-mcrypt php5-mysql php5-sqlite php5-xdebug \
  php-pear

# link /var/www to vagrant folder 
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

# install PHP Composer
if ! [ -f /usr/local/bin/composer ]; then
  curl -sS https://getcomposer.org/installer | php
  mv composer.phar /usr/local/bin/composer
  chmod +x /usr/local/bin/composer
fi

# start services
/etc/init.d/mysql start
/etc/init.d/apache2 start
