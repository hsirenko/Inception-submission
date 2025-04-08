#!/bin/bash

# Initialize the database if necessary
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Set proper permissions
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql

# Start MariaDB
mysqld_safe &

# Wait for MariaDB to be ready
until mysqladmin ping -h localhost --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# Secure the installation
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');"
mysql -e "FLUSH PRIVILEGES;"

# Create database and user
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# wait for the mysqld_safe process
wait %1