# generatedomain

A simple bash script to create and configure a new domain for Nginx.

## Overview

The `generatedomain` script automates the process of setting up a new domain in Nginx. It creates the necessary directories, sets up the server block configuration, reloads Nginx, and updates the `/etc/hosts` file.

## Usage

To create a new domain, run the script with the desired domain name as an argument:
```bash
for apache
sudo createdomain
sudo removedomain
for nginx
sudo generatedomain 'domain name'
sudo deletedomain 'domain name'
```



### Example

To create or delete a new domain -- createdomain removedomain generatedomain deletedomain `test.local`, run:

## Manual Steps
``bash
sudo mv createdomain removedomain generatedomain deletedomain  /usr/local/bin/createdomain 
sudo chmod +x /usr/local/bin/createdomain removedomain generatedomain deletedomain 
```


