#!/bin/bash

# List of domain names
domains=(
"default.lan"
"default-test.lan"
)

# Reading the hosts file
hosts=`cat /etc/hosts`

for domain in ${domains[@]}; do
  #Create config file
  config_file="$PWD/config/apache2/sites-enabled/$domain.conf"
  if [ ! -f $config_file ]; then
      if [ ! -d "$PWD/config/apache2/sites-enabled" ]; then
        mkdir -p "$PWD/config/apache2/sites-enabled"
      fi
      echo "<VirtualHost *:80>
        ServerAdmin webmaster@$domain
        ServerName $domain
        DocumentRoot /home/www/sites/$domain

        <Directory /home/www/sites/$domain/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride None
            Require all granted
        </Directory>
      </VirtualHost>" >> $config_file
  fi
  #Create site folder
  site_folder="$PWD/sites/$domain"
  if [ ! -d $site_folder ]; then
    mkdir -p $site_folder
    echo "hello $domain :)" >> "$site_folder/index.html"
  fi
  #Add the missing domains file
  if [[ "$hosts" != *"$domain"* ]]; then
    echo "Add domain $domain"
    echo "127.0.0.1 $domain" >> /etc/hosts
  fi
done

pwd
echo "Try remove old build"
pwd
docker stop dev_server && docker rm dev_server
echo "Build new docker image"
pwd
docker build -t dev_server .
pwd
echo "Run docker image"
docker run --name dev_server -d -p 127.0.0.1:80:80 \
-v $PWD/sites:/home/www/sites \
-v $PWD/logs/apache2:/var/log/apache2 dev_server
pwd
echo "Server started!"