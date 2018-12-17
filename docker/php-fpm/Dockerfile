FROM phpdockerio/php72-fpm:latest
WORKDIR "/rtc-talker/rtc-talker-rest"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install curl php-memcached php7.2-pgsql php-xdebug php7.2-json php7.2-mbstring php7.2-curl php7.2-xml php7.2-mysql php7.2-pgsql php7.2-zip php7.2-bcmath php7.2-bz2 php7.2-gd php-imagick php7.2-interbase php7.2-phpdbg php-ssh2 php7.2-xsl php-yaml \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install git
RUN apt-get update \
    && apt-get -y install git \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer