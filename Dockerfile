FROM augustash/baseimage:1.0.0
MAINTAINER Pete McWilliams <pmcwilliams@augustash.com>

ARG DEBIAN_FRONTEND="noninteractive"

# environment
ENV PHP_VERSION 7.0
ENV APTLIST \
    php${PHP_VERSION} \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mcrypt \
    php${PHP_VERSION}-memcache \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip

# packages & configure
RUN \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends --no-install-suggests $APTLIST $BUILD_DEPS && \

    mkdir -p \
        /config/php/pool.d \
        /var/log/phpfpm && \
    ln -sf /dev/stdout /var/log/phpfpm/error.log && \

    curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer && \

    apt-get -yqq purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false $BUILD_DEPS && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# root filesystem
COPY rootfs /

# run s6 supervisor
ENTRYPOINT ["/init"]
EXPOSE 9000
