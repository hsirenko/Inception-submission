#!/bin/bash
trap "exit" TERM

sleep 20

cd /var/

# Ensure proper permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress
chmod -R 777 /var/www/wordpress/wp-content

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h mariadb -u root -p$$MYSQL_ROOT_PASSWORD --silent; do
    echo "MariaDB is not ready yet. Waiting..."
    sleep 2
done
echo "MariaDB is ready!"

# Create WordPress directory if it doesn't exist
if [ ! -d "/var/www/wordpress" ]; then
    mkdir -p /var/www/wordpress
fi

# Set proper permissions
chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress

# Check if WordPress is already installed
if [ -f "/var/www/wordpress/wp-config.php" ]; then
    echo "WordPress is already installed, skipping installation..."
else
    echo "Installing WordPress..."
    
    # Download WordPress
    wp core download --path=/var/www/wordpress --allow-root --force
    
    # Configure WordPress
    wp config create --path=/var/www/wordpress \
        --dbname=wordpress \
        --dbuser=hsirenko \
        --dbpass=qwerty \
        --dbhost=mariadb \
        --allow-root

    # Install WordPress
    wp core install --path=/var/www/wordpress \
        --url=https://hsirenko.42.fr \
        --title="Inception" \
        --admin_user=hsirenko \
        --admin_password=qwerty \
        --admin_email=hsirenko@student.42.fr \
        --allow-root

    # Create additional user
    wp user create --path=/var/www/wordpress \
        user user@example.com \
        --role=author \
        --user_pass=qwerty \
        --allow-root
fi

# Create PHP-FPM directory if it doesn't exist
if [ ! -d "/run/php" ]; then
    mkdir -p /run/php
    echo "Directory /run/php created successfully."
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm7.4 -F
