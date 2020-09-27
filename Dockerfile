FROM ubuntu:19.10
MAINTAINER Andrey Yasnikov <yasnikov@realweb.su>

# Указываем таймзону сервера
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Обновляем систему и устанавливаем базовые утилиты
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget nano apache2

# Устанавливаем PHP
RUN apt-get -y install php7.3 libapache2-mod-php7.3 php-mysql php-pear php-gd php-mbstring php-xml php-amqp php-soap php-bcmath php-intl php-opcache php-gmp

# Указываем имя сервера
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Копируем файлы конфигов Apache
ADD ./config/apache2/sites-enabled /etc/apache2/sites-enabled

# Запускаем apache
ENTRYPOINT ["apachectl", "-D", "FOREGROUND"]

# Пробрасываем порты
EXPOSE 80