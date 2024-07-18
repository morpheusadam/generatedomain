#!/bin/bash

# Check if domain name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <domain_name>"
  exit 1
fi

DOMAIN=$1
DOC_ROOT="/var/www/$DOMAIN"
CONFIG_FILE="/etc/httpd/conf/extra/$DOMAIN.conf"

# Create document root directory
sudo mkdir -p $DOC_ROOT

# Create a simple index.html
echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to $DOMAIN!</title>
</head>
<body>
    <h1>Hello, $DOMAIN!</h1>
</body>
</html>" | sudo tee $DOC_ROOT/index.html

# Create virtual host configuration
echo "<VirtualHost *:80>
    ServerAdmin webmaster@$DOMAIN
    DocumentRoot $DOC_ROOT
    ServerName $DOMAIN
    ErrorLog /var/log/httpd/$DOMAIN-error.log
    CustomLog /var/log/httpd/$DOMAIN-access.log combined

    <Directory $DOC_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>" | sudo tee $CONFIG_FILE

# Enable the new site by including it in the main Apache configuration
if ! grep -q "Include conf/extra/$DOMAIN.conf" /etc/httpd/conf/httpd.conf; then
    echo "Include conf/extra/$DOMAIN.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

# Restart Apache to apply changes
sudo systemctl restart httpd

echo "Domain $DOMAIN has been created and Apache has been restarted."
