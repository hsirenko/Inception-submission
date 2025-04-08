Let me break this down in simple terms:

### 1. Docker and Docker Compose
- **Docker**:
  - Works like a lightweight container system
  - Each container runs one specific service (like nginx, WordPress, or database)
  - Uses Dockerfile to build images with instructions for setting up a service

- **Docker Compose**:
  - Manages multiple Docker containers as a single application
  - Uses `docker-compose.yml` to define how services work together
  - In your project, it coordinates three services: MariaDB, WordPress, and Nginx

### 2. Docker Image: With vs Without Docker Compose
- **Without Docker Compose**:
  ```bash
  # Run containers individually
  docker run mariadb
  docker run wordpress
  docker run nginx
  ```
  - Have to manually manage network connections
  - Need to specify all parameters on command line
  - Harder to maintain and reproduce

- **With Docker Compose** (as in your project):
  ```yaml
  # From your docker-compose.yml
  services:
    mariadb:
      # Configuration for MariaDB
    wordpress:
      # Configuration for WordPress
    nginx:
      # Configuration for Nginx
  ```
  - All services defined in one file
  - Automatic network creation
  - Easy environment variable management
  - Simple commands (`docker-compose up`)

### 3. Docker vs VMs Benefits
- **Docker**:
  - Lightweight (shares host OS kernel)
  - Starts in seconds
  - Uses less resources
  - Easy to distribute and version
  - Perfect for microservices (like your WordPress setup)

- **VMs**:
  - Run full OS copy
  - Take minutes to start
  - Use more resources
  - Harder to distribute
  - Better for full system isolation

### 4. Directory Structure Pertinence
Your project structure:
```
srcs/
├── requirements/
│   ├── mariadb/
│   │   ├── conf/
│   │   ├── tools/
│   │   └── Dockerfile
│   ├── nginx/
│   │   ├── conf/
│   │   └── Dockerfile
│   └── wordpress/
│       ├── conf/
│       ├── tools/
│       └── Dockerfile
├── .env
└── docker-compose.yml
```

**Benefits of this structure**:
- **Separation of Concerns**: Each service has its own directory
- **Maintainability**: Configuration files separated from scripts
- **Scalability**: Easy to add new services
- **Organization**: Clear distinction between different components
- **Reusability**: Each service can be used independently

For example, in your WordPress service:
- `conf/` contains PHP-FPM configuration
- `tools/` contains setup scripts
- Dockerfile defines how to build the service

This structure makes it easy to:
1. Debug issues (files are logically organized)
2. Make changes (each component is isolated)
3. Understand the system (clear separation of responsibilities)
4. Deploy the application (everything is well-structured)


SIMPLE SETUP
verify 443 port for NGINX:
# Test NGINX configuration
docker exec nginx nginx -t

# Check listening ports
docker exec nginx ss -tuln


# Testing NGINX HTTP Access Restriction

Let's verify that NGINX is only accessible via HTTPS (port 443) and not HTTP (port 80).

1. First, check if port 80 is blocked by trying to connect:
```bash
curl http://hsirenko.42.fr
# This should fail to connect
```

2. Check NGINX's listening ports:
```bash
docker exec nginx ss -tuln
```

You should only see port 443 listening:
```
tcp   LISTEN 0      511          0.0.0.0:443        0.0.0.0:*
tcp   LISTEN 0      511             [::]:443           [::]:*
```

3. Verify the configuration in your files:

In nginx.conf:
```nginx
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    # No port 80 listener defined
}
```

In docker-compose.yml:
```yaml
nginx:
    ports:
      - "443:443"
    # No port 80 mapping
```

To test HTTPS access (which should work):
```bash
curl -k https://hsirenko.42.fr
```

The `-k` flag is used because we're using a self-signed certificate.



# TLS Configuration Check

Looking at your NGINX configuration in nginx.conf, you have properly configured TLS v1.2/v1.3:

```nginx
# SSL configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_certificate /etc/nginx/ssl/inception.crt;
ssl_certificate_key /etc/nginx/ssl/inception.key;
```

To verify this:

1. **Check SSL Certificate Setup**
The certificate is generated in your Dockerfile:
```dockerfile
RUN mkdir -p /etc/nginx/ssl /var/www/html && \
    openssl req -x509 -nodes \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=FR/ST=Berlin/L=Berlin/O=42/OU=42/CN=hsirenko.42.fr/UID=hsirenko/"
```

2. **Verify TLS Version**
Run these commands to check:


# Check TLS version supported

curl -Iv --tlsv1.2 --insecure https://hsirenko.42.fr 
# Should work

curl -Iv --tlsv1.3 --insecure https://hsirenko.42.fr
# Should work
```

3. **Additional Verification**

# Check SSL certificate details
openssl s_client -connect hsirenko.42.fr:443 -tls1_2
openssl s_client -connect hsirenko.42.fr:443 -tls1_3




# MariaDB Login Security Check

Let's test the database security by attempting to log in as root. Here's how to test both secured and unsecured access:

1. **Try logging in without password (should fail)**:
```bash
docker exec -it mariadb mysql -u root
```

2. **Correct way to login with password**:
```bash
docker exec -it mariadb mysql -u root -p${MARIADB_ROOT_PASSWORD}
```

Your configuration is secure because:

1. In Dockerfile, root password is set:
```dockerfile
ENV MYSQL_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD}
```

2. In script.sh, proper permissions are set:
```bash
# Create database and user
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
```

3. In docker-compose.yml, environment variables are properly passed:

environment:
  MYSQL_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}


To verify security:

# This should fail
docker exec -it mariadb mysql -u root

# This should work
docker exec -it mariadb mysql -u root -p${MARIADB_ROOT_PASSWORD}
docker exec -it mariadb mysql -u root -pqwerty


 Test Connection
After connecting, you can verify the setup:
SHOW DATABASES;
USE wordpress;
SHOW TABLES;


# Testing MariaDB User Access and Database Content

Let's log in with the WordPress user credentials and check the database content:

1. **Login with WordPress User**:
```bash
docker exec -it mariadb mysql -u${MARIADB_USER} -p${MARIADB_PASSWORD} ${MYSQL_DATABASE}
```

Or using the values from your `.env` file:
```bash
docker exec -it mariadb mysql -uhsirenko -pqwerty wordpress
```

2. **Check Database Content**:
Once logged in, run these commands:

-- Show all tables
SHOW TABLES;

-- Check users table content
SELECT * FROM wp_users;



