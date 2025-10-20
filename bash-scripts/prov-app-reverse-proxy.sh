#!/bin/bash

# Purpose: Provision and deploy the Java Spring Boot 'Library' app
# Environment: AWS EC2 (Ubuntu 22.04 LTS)
# Goal: Idempotent setup on a fresh VM
# Tested by: Charley Bolton
# Date tested: 20/10/2025

echo "==============================================="
echo "Starting provisioning of Library app VM..."
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

# --- Install Java (OpenJDK 17) ---
echo "Installing OpenJDK 17..."
sudo DEBIAN_FRONTEND=noninteractive apt install openjdk-17-jdk -y
echo "Java installation complete."
echo

# --- Configure JAVA_HOME ---
echo "Setting JAVA_HOME environment variable..."
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"
source ~/.profile
echo "JAVA_HOME set to: $JAVA_HOME"
echo

# Verify Java installation
echo "Verifying Java version..."
java -version
echo

# --- Clone Application Repository ---
WORKDIR="$(pwd)"

echo "Cloning application repository..."
git clone https://github.com/charleybolton/sparta-second-app.git "$WORKDIR/library-java17-mysql-app" || echo "Repository already cloned, continuing..."
echo "Repository ready at: $WORKDIR/library-java17-mysql-app"
echo

# --- Install Maven ---
echo "Installing Maven..."
sudo DEBIAN_FRONTEND=noninteractive apt install maven -y
echo "Maven installation complete."
echo

# --- Build Application ---
echo "Building the Spring Boot application..."
cd "$WORKDIR/library-java17-mysql-app/LibraryProject2"
mvn clean install -DskipTests
echo "Build complete."
echo

# --- Install and Configure Nginx Reverse Proxy ---
echo "Installing Nginx..."
sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y
echo "Nginx install done."
echo

echo "Restarting Nginx..."
sudo systemctl restart nginx
echo "Nginx restart done."
echo

echo "Backing up Nginx default site config..."
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak-$(date +%F-%H%M%S)
echo "Backup created."
echo

echo "Updating Nginx config to proxy requests to app on port 5000..."
sudo sed -i 's|try_files \$uri \$uri/ =404;|proxy_pass http://127.0.0.1:5000/;|' /etc/nginx/sites-available/default
echo "Nginx config updated."
echo

echo "Testing Nginx configuration..."
sudo nginx -t
echo "Nginx config test passed."
echo

echo "Restarting Nginx..."
sudo systemctl restart nginx
echo "Nginx restarted and proxy active."
echo

# --- Configure Environment Variables ---
DATABASE_IP="3.251.92.76"

echo "Setting database environment variables..."
export DB_HOST="jdbc:mysql://$DATABASE_IP:3306/library"
export DB_USER="root"
export DB_PASS=""
echo "Environment variables configured:"
echo "   DB_HOST = $DB_HOST"
echo "   DB_USER = $DB_USER"
echo

# --- Stop and Start Application ---
echo "Stopping any existing Spring Boot instance..."
mvn spring-boot:stop || true
echo "Spring Boot stop attempted."
echo

echo "Starting the Spring Boot application..."
mvn spring-boot:start
echo "Spring Boot started successfully."
echo

echo "==============================================="
echo "Provisioning and deployment complete!"
echo "==============================================="
