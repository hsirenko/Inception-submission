#!/bin/bash

# Initialize the database if necessary
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB
mysqld_safe &

# Wait for MariaDB to be ready
until mysqladmin ping -h localhost -u root -p$$MYSQL_ROOT_PASSWORD --silent; do
    sleep 2
done

# Create database and user
mysql -u root -p$$MYSQL_ROOT_PASSWORD << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Keep the container running
tail -f /dev/null