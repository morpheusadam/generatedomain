#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Get the domain name from the user
read -p "Enter the domain name (e.g., example.com): " DOMAIN

# Define paths
WEB_ROOT="/srv/http/$DOMAIN"
APACHE_CONFIG="/etc/httpd/conf/extra/$DOMAIN.conf"
HOSTS_FILE="/etc/hosts"

# Create the web root directory
mkdir -p $WEB_ROOT

# Create a simple index.html file
echo "<html><body><h1>Hello $DOMAIN</h1></body></html>" > $WEB_ROOT/index.html

# Create the Apache virtual host configuration
cat <<EOL > $APACHE_CONFIG
<VirtualHost *:80>
    ServerAdmin webmaster@$DOMAIN
    ServerName $DOMAIN
    DocumentRoot $WEB_ROOT
    ErrorLog /var/log/httpd/$DOMAIN-error.log
    CustomLog /var/log/httpd/$DOMAIN-access.log combined
    <Directory $WEB_ROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOL

# Add the domain to the hosts file
echo "127.0.0.1 $DOMAIN" >> $HOSTS_FILE

# Enable the new site by including it in the main Apache configuration
echo "Include conf/extra/$DOMAIN.conf" >> /etc/httpd/conf/httpd.conf

# Restart Apache to apply the changes
systemctl restart httpd

echo "Domain $DOMAIN has been set up and is available at http://$DOMAIN"
