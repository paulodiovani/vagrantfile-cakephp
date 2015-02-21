# PHP Vagrant config

This repository contain a `Vagrantfile` and a `bootstrap.sh`
for creating a vagrant environment for CakePHP (and problably
will work for other PHP frameworks).

## Installed software

* PHP 5.4 (with XDebug)

* MySQL 5.5
  user and password are `root:root`

* Apache 2.2
  running on host port 8080
  `DocumentRoot` is `/var/www`, wich is a symbolic link to `/vagrant`

* PHPMyAdmin
  access on host at `http://localhost:8080/phpmyadmin`

* PHP Composer
