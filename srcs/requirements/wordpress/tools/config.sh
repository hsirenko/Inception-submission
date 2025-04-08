#!/bin/bash

# Wait for MariaDB to be ready
while ! mysqladmin ping -h"$MARIADB_HOST" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

echo "MariaDB is ready!"
cd /var/www/wordpress

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Installing WordPress..."
    wp core download --allow-root
    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MARIADB_USER" \
        --dbpass="$MARIADB_PASSWORD" \
        --dbhost="$MARIADB_HOST" \
        --dbcharset="utf8" \
        --dbcollate="utf8_general_ci"
    
    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}"

    wp user create --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}"
fi

# Set proper permissions before starting PHP-FPM
find /var/www/wordpress -type d -exec chmod 777 {} \;
find /var/www/wordpress -type f -exec chmod 644 {} \;

# Ensure wp-content and its subdirectories have proper permissions
chmod 777 /var/www/wordpress/wp-content
chmod -R 777 /var/www/wordpress/wp-content/themes
chmod -R 777 /var/www/wordpress/wp-content/plugins
chmod -R 777 /var/www/wordpress/wp-content/upgrade
chown -R www-data:www-data /var/www/wordpress

# Start PHP-FPM
mkdir -p /run/php
php-fpm7.4 -F
