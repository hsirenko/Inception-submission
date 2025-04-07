FROM debian:bullseye

# Set environment variables for MariaDB
ENV MYSQL_DATABASE=wordpress \
    MYSQL_USER=hsirenko \
    MYSQL_PASSWORD=qwerty \
    MYSQL_ROOT_PASSWORD=qwerty

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create the data directory and set permissions
RUN mkdir -p /var/log/mysql && \
    chown -R mysql:mysql /var/log/mysql

# RUN mkdir -p ${USER_HOME}/data/mariadb && \
#     chown -R 999:999 ${USER_HOME}/data/mariadb

# # Create the logs directory for MariaDB
# RUN mkdir -p /logs/mariadb && \
#     chown -R mysql:mysql /logs/mariadb

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/script.sh /usr/local/bin/

# Expose MariaDB port
EXPOSE 3306

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["/usr/local/bin/script.sh"]
