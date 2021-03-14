#!/bin/bash

# Create DNS settings file
dns_config_folder="$PWD/config/dns"
if [ -d $dns_config_folder ]; then
    rm -r -f $dns_config_folder
fi
mkdir -p $dns_config_folder

IFS=$'\n'
for domain in $(cat domains.conf)
do
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
            AllowOverride All
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

  #Add DNS records
  echo -e "domain=$domain" >> "$dns_config_folder/dnsmasq.conf"
  echo -e "address=/$domain/127.0.0.1" >> "$dns_config_folder/dnsmasq.conf"
done

#Start!
docker-compose up