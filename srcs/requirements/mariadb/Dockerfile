FROM debian:bullseye

# Set environment variables for MariaDB
ENV MYSQL_DATABASE=${MYSQL_DATABASE} \
    MYSQL_USER=${MARIADB_USER} \
    MYSQL_PASSWORD=${MARIADB_PASSWORD} \
    MYSQL_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD}

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql && \
    chmod 777 /var/run/mysqld


COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/script.sh /usr/local/bin/

# Expose MariaDB port
EXPOSE 3306

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["/usr/local/bin/script.sh"]
