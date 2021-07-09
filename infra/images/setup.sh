#!/bin/bash
set -e

# Install dependencies
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install curl wget git vim apt-transport-https ca-certificates nginx

# Setup NodeJS 14.x
curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install nodejs
sudo npm install pm2@latest -g

# Setup sudo to allow no-password sudo for "hashicorp" group and adding "terraform" user
sudo groupadd -r hashicorp
sudo useradd -m -s /bin/bash terraform
sudo usermod -a -G hashicorp terraform
sudo cp /etc/sudoers /etc/sudoers.orig
echo "terraform ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform

# Change deployment directory path and permissions
sudo mkdir -p /var/app
sudo chown -R ubuntu:ubuntu /var/app

# Setup nginx
# Remove the default configuration
sudo sh -c '> /etc/nginx/sites-available/default' && \
sudo sh -c 'sudo cat <<EOF > /etc/nginx/sites-available/default
upstream app_upstream {
  server 127.0.0.1:3000;
  keepalive 64;
}

server {
  listen 80 default_server;
  listen [::]:80 default_server;
  server_name _;

  location / {
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header Host \$http_host;
      
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
      
    proxy_pass http://app_upstream/;
    proxy_redirect off;
    proxy_read_timeout 240s;
  }
}
EOF'
