#!/usr/bin/env bash

# update apt database
aptitude update

# debconf selections
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'

# install everything we need
DEBIAN_FRONTEND=noninteractive aptitude install -y \
  debconf-utils build-essential \
  vim git curl \
  mysql-server \
  apache2 imagemagick \
  php5 php5-curl php5-gd php5-imagick php5-json \
  php5-mcrypt php5-mysql php5-sqlite php5-xdebug \
  php-pear phpmyadmin

# link /var/www to vagrant folder 
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

# enable mod-rewrite
if ! [ -L /etc/apache2/mods-enabled/rewrite.load ]; then
  pushd /etc/apache2/mods-enabled
  ln -fs ../mods-available/rewrite.load
  popd
  # restart web server
  /etc/init.d/apache2 restart
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
