FROM ubuntu:latest
MAINTAINER Andrey Yasnikov <yasnikov@realweb.su>

# Setting the server timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# We update the system and install basic utilities
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget nano apache2

# Install PHP
RUN apt-get -y install php7.3 libapache2-mod-php php-mysql php-pear php-gd php-mbstring php-xml php-amqp php-soap php-bcmath php-intl php-opcache php-gmp

# Setting the server name
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copying the Apache config files
ADD ./config/apache2/sites-enabled /etc/apache2/sites-enabled

# Run Apache
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]

EXPOSE 80
