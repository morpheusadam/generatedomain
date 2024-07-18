#!/bin/bash

# Prompt the user for the domain name
read -p "Please choose domain name: " domain

# Define the domain name with .local
domain_name="${domain}.local"

# Create the directory for the new domain
sudo mkdir -p /var/www/${domain_name}

# Create a simple index.html file
echo "<html><body><h1>Hello ${domain_name}</h1></body></html>" | sudo tee /var/www/${domain_name}/index.html

# Create a new Apache configuration file for the domain
sudo tee /etc/httpd/conf/extra/${domain_name}.conf > /dev/null <<EOL
<VirtualHost *:80>
    ServerName ${domain_name}
    DocumentRoot /var/www/${domain_name}
    <Directory /var/www/${domain_name}>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog /var/log/httpd/${domain_name}_error.log
    CustomLog /var/log/httpd/${domain_name}_access.log combined
</VirtualHost>
EOL

# Include the new configuration in the main Apache configuration file
if ! grep -q "Include conf/extra/${domain_name}.conf" /etc/httpd/conf/httpd.conf; then
    echo "Include conf/extra/${domain_name}.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

# Restart Apache to apply the changes
sudo systemctl restart httpd

# Add the domain to /etc/hosts
if ! grep -q "127.0.0.1 ${domain_name}" /etc/hosts; then
    echo "127.0.0.1 ${domain_name}" | sudo tee -a /etc/hosts
fi

echo "Your domain ${domain_name} has been created."
