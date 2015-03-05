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
  php5-intl \
  php-pear phpmyadmin

# link /var/www to vagrant folder 
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant/www /var/www
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

# change apache user to vagrant
if grep -q 'APACHE_RUN_USER=www-data' /etc/apache2/envvars; then
  sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars
fi

# change apache group to vagrant
if grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars; then
  sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars
fi

# change owner of /var/lock/apache2
chown -R vagrant:www-data /var/lock/apache2

# start services
/etc/init.d/mysql restart
/etc/init.d/apache2 restart
