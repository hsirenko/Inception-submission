#!/bin/bash

# Start MariaDB service
service mariadb start

# Wait for MariaDB to be ready
until mysqladmin ping -h localhost -u root -p$$MYSQL_ROOT_PASSWORD --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# Initialize the database if necessary
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB database..."
    # mysql -u root -p$$MYSQL_ROOT_PASSWORD << EOF
     mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
     mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
     mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
     mysql -u root -e "FLUSH PRIVILEGES;"
# EOF
fi

# Keep the container running
#tail -f /var/log/mysql/error.log
tail -f /dev/null