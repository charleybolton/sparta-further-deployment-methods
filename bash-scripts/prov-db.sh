#!/bin/bash

# Purpose: Provision and deploy the MySQL database for the 'Library' app
# Environment: AWS EC2 (Ubuntu 22.04 LTS)
# Goal: Idempotent setup on a fresh VM
# Tested by: Charley Bolton
# Date tested: 20/10/2025

echo "==============================================="
echo "Starting provisioning of Library database VM..."
echo "==============================================="
echo

# --- System Update & Upgrade ---
echo "Updating package lists..."
sudo apt update -y
echo "Package list update complete."
echo

echo "Upgrading installed packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "System upgrade complete."
echo

# --- Install and Start MySQL ---
echo "Installing MySQL server..."
sudo DEBIAN_FRONTEND=noninteractive apt install mysql-server -y
echo "MySQL installation complete."
echo

# --- Verify MySQL Installation ---
mysql --version
echo

# --- Backup MySQL Config ---
echo "Backing up MySQL config..."
sudo cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak.$(date +%F-%H%M%S)
echo "Backup created at /etc/mysql/my.cnf.bak.$(date +%F-%H%M%S)"
echo

# --- Start MySQL Service ---
echo "Starting MySQL service..."
sudo systemctl start mysql.service
echo "MySQL service started."
echo

# --- Update MySQL Bind IP ---
echo "Updating MySQL bind-address to allow remote access..."
sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
echo "bind-address updated to 0.0.0.0"
echo

# --- Restart MySQL ---
echo "Restarting MySQL..."
sudo systemctl restart mysql
echo "MySQL restarted with updated bind-address."
echo

# --- Allow Remote Access for App Server ---
echo "Granting remote access for all external app servers (testing)..."
sudo mysql -u root <<EOF
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
echo "Remote access granted for all app servers."
echo

# APP_IP="34.254.226.172"

# echo "Granting remote access for app server at $APP_IP..."
# sudo mysql -u root <<EOF
# CREATE USER IF NOT EXISTS 'root'@'$APP_IP' IDENTIFIED BY '';
# GRANT ALL ON *.* TO 'root'@'$APP_IP' WITH GRANT OPTION;
# FLUSH PRIVILEGES;
# EOF
# echo "Remote access granted for app server at $APP_IP."
# echo

# --- Clone Application Repository ---
WORKDIR="$(pwd)"

echo "Cloning application repository..."
git clone https://github.com/charleybolton/sparta-second-app.git "$WORKDIR/library-java17-mysql-app" || echo "Repository already cloned, continuing..."
echo "Repository ready at: $WORKDIR/library-java17-mysql-app"
echo

# --- Create and Seed Database ---
echo "Creating and seeding database..."
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS library;
USE library;
SOURCE $WORKDIR/library-java17-mysql-app/library.sql;
EOF
echo "Database 'library' created and seeded."
echo

echo "==============================================="
echo "Database provisioning complete!"
echo "==============================================="