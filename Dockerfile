FROM ubuntu:latest
MAINTAINER Andrey Yasnikov <yasnikov@realweb.su>

# Setting the server timezone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# We update the system and install basic utilities
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget nano apache2

# Install PHP
RUN apt-get -y install php7.4 libapache2-mod-php php-mysql php-pear php-gd php-mbstring php-xml php-amqp php-soap php-bcmath php-intl php-opcache php-gmp php-pear

# Install Xdebug
ARG XDEBUG_CONFIG_PATH=/etc/php/7.4/mods-available/xdebug.ini

RUN apt-get -y install php-xdebug php7.4-dev
RUN echo 'xdebug.remote_enable=1' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.remote_host="host.docker.internal"' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.remote_autostart = 1' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.remote_port = 9000' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.remote_connect_back = 0' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.profiler_enable = 0' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.profiler_enable_trigger = 1' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.profiler_output_dir = "/home/www/xdebug_profiler/"' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.profiler_output_name = "cachegrind.out.%t-%s"' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.max_nesting_level = 512' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.idekey = PHPSTORM' >> $XDEBUG_CONFIG_PATH
RUN echo 'xdebug.file_link_format = "phpstorm://open?%f:%l"' >> $XDEBUG_CONFIG_PATH

# Setting the server name
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copying the Apache config files
ADD ./config/apache2/sites-enabled /etc/apache2/sites-enabled

RUN a2enmod rewrite

# Run Apache
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]

EXPOSE 80 9000
