FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl /var/www/html && \
    openssl req -x509 -nodes \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=FR/ST=Berlin/L=Berlin/O=42/OU=42/CN=hsirenko.42.fr/UID=hsirenko/"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]

