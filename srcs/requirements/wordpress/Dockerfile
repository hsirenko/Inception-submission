FROM debian:bullseye

# Set environment variables for MariaDB
ENV MYSQL_DATABASE=wordpress \
    MYSQL_USER=hsirenko \
    MYSQL_PASSWORD=qwerty \
    MYSQL_ROOT_PASSWORD=qwerty

# Install necessary packages
RUN apt update -y && apt upgrade -y && \
    apt-get -y install wget unzip php7.4 php-fpm php-mysql mariadb-client php-redis && \
    rm -rf /var/lib/apt/lists/*

# Download and set up WordPress
WORKDIR /var/www
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && rm latest.zip && \
    chown -R www-data:www-data /var/www

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM configuration
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Add the configuration script
COPY tools/config.sh /config.sh
RUN chmod +x /config.sh

# Expose MariaDB port
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["/config.sh"]




# # Download and set up WordPress
# WORKDIR /var/www
# RUN wget https://wordpress.org/latest.zip && \
#     unzip latest.zip && rm latest.zip && \
#     chown -R www-data:www-data /var/www/wordpress && \
#     chmod -R 755 /var/www/wordpress && \
#     chmod -R 777 /var/www/wordpress/wp-content

# # Install WP-CLI
# RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
#     chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# # Copy PHP-FPM configuration
# COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# # Add the configuration script
# COPY tools/config.sh /config.sh
# RUN chmod +x /config.sh

# # Set entrypoint
# ENTRYPOINT ["/config.sh"]

