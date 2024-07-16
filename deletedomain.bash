#!/bin/bash

# Check if domain name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 domain_name"
    exit 1
fi

DOMAIN=$1
WEB_ROOT="/var/www/$DOMAIN"
NGINX_AVAILABLE="/etc/nginx/sites-available/$DOMAIN"
NGINX_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"

# Remove the web root directory
if [ -d "$WEB_ROOT" ]; then
    sudo rm -rf $WEB_ROOT
    echo "Removed web root directory: $WEB_ROOT"
else
    echo "Web root directory does not exist: $WEB_ROOT"
fi

# Remove the Nginx server block configuration
if [ -f "$NGINX_AVAILABLE" ]; then
    sudo rm $NGINX_AVAILABLE
    echo "Removed Nginx available configuration: $NGINX_AVAILABLE"
else
    echo "Nginx available configuration does not exist: $NGINX_AVAILABLE"
fi

# Remove the symbolic link in sites-enabled
if [ -L "$NGINX_ENABLED" ]; then
    sudo rm $NGINX_ENABLED
    echo "Removed Nginx enabled configuration: $NGINX_ENABLED"
else
    echo "Nginx enabled configuration does not exist: $NGINX_ENABLED"
fi

# Remove the domain from /etc/hosts
sudo sed -i "/$DOMAIN/d" /etc/hosts
echo "Removed $DOMAIN from /etc/hosts"

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx

echo "Domain $DOMAIN has been deleted and Nginx has been reloaded."
