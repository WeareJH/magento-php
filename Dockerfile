FROM php:7.1-fpm-alpine
MAINTAINER Michael Woodward <michael@wearejh.com>

RUN apk update \
  && apk add \
    icu-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libltdl \
    libmcrypt-dev \
    libpng-dev \
    libxslt-dev \
    msmtp \
    git \
    vim

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    xsl \
    zip \
    soap \
    bcmath \
    mysqli \
    opcache \
    pcntl

# Configuration files
COPY etc/custom.template etc/xdebug.template /usr/local/etc/php/conf.d/
COPY etc/msmtprc.template /etc/msmtprc.template

# Copy in Entrypoint file & Magento installation script
COPY bin/docker-configure bin/magento-install bin/magento-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-configure /usr/local/bin/magento-install /usr/local/bin/magento-configure

# Composer
RUN  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

RUN rm -rf html && mkdir pub && mkdir var && mkdir -p app/etc

VOLUME ["/var/www"]
ENTRYPOINT ["/usr/local/bin/docker-configure"]
CMD ["php-fpm"]
