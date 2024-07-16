# generatedomain

A simple bash script to create and configure a new domain for Nginx.

## Overview

The `generatedomain` script automates the process of setting up a new domain in Nginx. It creates the necessary directories, sets up the server block configuration, reloads Nginx, and updates the `/etc/hosts` file.

## Usage

To create a new domain, run the script with the desired domain name as an argument:

### Example

To create a new domain `test.local`, run:

## Manual Steps

If you prefer to set up a new domain manually, follow these steps:

1. **Create the Web Root Directory**:
    ```sh
    sudo mkdir -p /var/www/test.local/html
    ```

2. **Set Permissions**:
    ```sh
    sudo chown -R $USER:$USER /var/www/test.local/html
    sudo chmod -R 755 /var/www/test.local
    ```

3. **Create a Sample `index.html` File**:
    ```sh
    echo "<html><head><title>Welcome to test.local</title></head><body><h1>Success! test.local is working!</h1></body></html>" | sudo tee /var/www/test.local/html/index.html
    ```

4. **Create the Nginx Server Block Configuration**:
    ```sh
    sudo nano /etc/nginx/sites-available/test.local
    ```

    Add the following content:
    ```nginx
    server {
        listen 80;
        server_name test.local;

        root /var/www/test.local/html;
        index index.html;

        error_log /var/log/nginx/test.local.error.log;
        access_log /var/log/nginx/test.local.access.log;

        location / {
            try_files $uri $uri/ =404;
        }
    }
    ```

5. **Enable the Server Block by Creating a Symbolic Link**:
    ```sh
    sudo ln -s /etc/nginx/sites-available/test.local /etc/nginx/sites-enabled/
    ```

6. **Test Nginx Configuration**:
    ```sh
    sudo nginx -t
    ```

7. **Reload Nginx to Apply Changes**:
    ```sh
    sudo systemctl reload nginx
    ```

8. **Update the `/etc/hosts` File**:
    ```sh
    echo "127.0.0.1 test.local" | sudo tee -a /etc/hosts
    ```

## Requirements

- Nginx installed and running.
- Sudo privileges.

## Installation

1. Copy the `generatedomain` script to `/usr/local/bin`:

    ```sh
    sudo cp generatedomain /usr/local/bin/generatedomain
    ```

2. Make the script executable:

    ```sh
    sudo chmod +x /usr/local/bin/generatedomain
    ```

## License

This project is licensed under the MIT License.
