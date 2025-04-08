FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
    wget \
    unzip \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-common \
    php7.4-curl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-gd \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create directories and set permissions in correct order
RUN mkdir -p /var/www/wordpress /run/php && \
    mkdir -p /var/www/wordpress/wp-content/themes && \
    mkdir -p /var/www/wordpress/wp-content/plugins && \
    mkdir -p /var/www/wordpress/wp-content/upgrade && \
    chown -R www-data:www-data /var/www/wordpress /run/php && \
    chmod -R 777 /var/www/wordpress && \
    chmod -R 777 /var/www/wordpress/wp-content

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy configuration files
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/config.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/config.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["config.sh"]
