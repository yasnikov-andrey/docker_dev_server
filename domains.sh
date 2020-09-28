#!/bin/bash

if [ $USER != 'root' ]
  then
    echo "You must be root to do this."
    exit
fi

# Reading the hosts file
hosts=`cat /etc/hosts`

IFS=$'\n'
for domain in $(cat domains.conf)
do
  #Add the missing domains file
  if [[ "$hosts" != *"$domain"* ]]; then
    echo "Add domain $domain"
    echo "127.0.0.1 $domain" >> /etc/hosts
  fi
done