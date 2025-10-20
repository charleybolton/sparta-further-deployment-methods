# Library Java 17 MySQL Application — AWS 2-Tier Deployment Guide (Virtual Machines)

This documentation outlines the process of deploying the **Library Java Spring Boot Application** and **MySQL Database** onto AWS EC2 instances using Bash provisioning scripts executed via **User Data**.

> **User Data:** A startup script that runs automatically when an EC2 instance first boots, allowing software to be installed and configured without manual SSH access.

The setup represents a classic **2-tier architecture** — separating the **application layer** and the **database layer** across two virtual machines.

---

## 1. Overview

The deployment uses two EC2 instances running Ubuntu 22.04 LTS:

- **App VM** – Hosts the Java 17 Spring Boot web application (via Maven).  
- **DB VM** – Hosts the MySQL database that stores application data.

The process is fully automated through Bash scripts that run during instance boot (User Data).  

Each script installs dependencies, configures networking, and deploys the service automatically.

---

## 2. Architecture Diagram

┌──────────────┐        ┌────────────────────┐        ┌────────────────────┐
│  User        │  HTTP  │  Nginx Reverse     │  TCP   │  MySQL Database     │
│  Browser     │ ─────► │  Proxy (Port 80)   │ ─────► │  (Port 3306)        │
└──────────────┘        │  → Spring Boot     │        └────────────────────┘
                        │    App (Port 5000) │
                        └────────────────────┘


---

## 3. Key Technologies

The core technologies — **Java 17**, **Spring Boot**, and **MySQL** — are explained in detail in the *Local Deployment* README.

This section focuses on what changes when deploying automatically on AWS, plus one new addition: **Nginx** for reverse proxying.

---

### Java 17 (OpenJDK)

Java 17 is installed automatically via `apt` in the Bash script instead of manually with Homebrew. 

Both methods achieve the same outcome — a fully functional Java 17 JDK that includes the compiler and runtime needed to run Spring Boot applications.  

The only differences are in how the package is delivered and updated:  
- **Homebrew (Temurin 17)** is the Adoptium build used on macOS.  
- **`apt install openjdk-17-jdk`** is the Ubuntu-packaged OpenJDK build used on AWS.  

Functionally, both provide the same Java environment and are equally valid choices.

---

### Spring Boot

Spring Boot is built and run automatically using Maven commands inside the provisioning script (`mvn clean install` then `mvn spring-boot:start`).

The app still runs on port **5000**, but in this cloud setup it is proxied through **Nginx** on port **80**, so users can access it in a browser without typing the port number.

---

### MySQL

MySQL is deployed on its own EC2 instance and configured to accept external connections over **port 3306**.

By default, MySQL only listens on `localhost`, so the script updates the configuration to `0.0.0.0`, allowing the app server to connect remotely.

A new MySQL user is created with permissions for the app’s IP (or `%` wildcard when automated).

### Nginx (Reverse Proxy)

Nginx is installed on the **app VM** to act as a reverse proxy.

It forwards incoming HTTP traffic on port 80 to the Spring Boot application running on port 5000.  

This allows the site to be accessible without needing to specify :5000 in the browser.

---

## 4. Security Group Configuration (for Testing)

| Resource | Type | Protocol | Port | Source | Purpose |
|-----------|------|-----------|-------|---------|----------|
| **App VM** | SSH | TCP | 22 | My IP | Administrative access |
|  | HTTP | TCP | 80 | 0.0.0.0/0 | Public web access |
|  | App Port | TCP | 5000 | 0.0.0.0/0 | Optional direct app access |
| **DB VM** | SSH | TCP | 22 | My IP | Administrative access |
|  | MySQL | TCP | 3306 | 0.0.0.0/0 | Temporary open DB access for testing |

**Notes:**
- SSH should remain restricted to a trusted IP address.  
- Port 3306 can be temporarily open for simplicity, but in production it should only allow traffic from the app VM’s IP.  
- HTTP (80) provides public web access via Nginx.

---

## 5. Bash Provisioning Scripts

Both VMs use Bash scripts executed through **User Data** on instance creation.

### 5.1 Database Provisioning Script

This script performs the following:

1. Updates and upgrades system packages  
2. Installs MySQL Server  
3. Configures MySQL to allow remote access  
4. Grants privileges to the app server (temporarily open to all hosts for user-data automation)  
5. Clones the app repository and seeds the database with initial data from library.sql  

During setup, the script also **creates and seeds the database automatically** so it’s ready before the app connects:

```bash
sudo mysql -u root <<EOF  
CREATE DATABASE IF NOT EXISTS library;  
USE library;  
SOURCE $WORKDIR/library-java17-mysql-app/library.sql;  
EOF  
```

This loads the predefined schema and example data from the project’s SQL file.

Key configuration changes include:
- Updating `/etc/mysql/mysql.conf.d/mysqld.cnf` to set  
  `bind-address = 0.0.0.0` — this allows the database to accept connections from external hosts (such as the app VM).  
- Creating and granting a root user accessible from any host:

```sql
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';  
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;  
FLUSH PRIVILEGES;
```  

---

### 5.2 Application Provisioning Script

This script sets up and deploys the Spring Boot application:

1. Updates system packages  
2. Installs Java (OpenJDK 17)  
3. Configures JAVA_HOME  
   - The script sets the `JAVA_HOME` environment variable so the system knows where Java is installed:
    ```bash  
     export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64  
     export PATH="$JAVA_HOME/bin:$PATH"  
     source ~/.profile  
     This ensures Java commands and Maven can be run from anywhere on the system.
     ```  
4. Installs Maven  
5. Clones the application repository  
6. Builds the project with Maven (`mvn clean install -DskipTests`)  
7. Sets environment variables for database connection:  
   - The app uses environment variables to connect to the database dynamically without hardcoding credentials:
    ```bash  
     DATABASE_IP="<db-public-ip>"  
     export DB_HOST="jdbc:mysql://$DATABASE_IP:3306/library"  
     export DB_USER="root"  
     export DB_PASS=""
     ```  
8. Starts the Spring Boot app using Maven (`mvn spring-boot:start`)  
9. Installs and configures Nginx to proxy traffic from port 80 to port 5000:  
   - The script updates `/etc/nginx/sites-available/default` so that requests to port 80 are automatically forwarded to the Spring Boot app running on port 5000.  
     This makes the web app accessible at `http://<app-ip>` instead of `http://<app-ip>:5000`.  

```bash
sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://127.0.0.1:5000/;|' /etc/nginx/sites-available/default  
sudo systemctl restart nginx
```  
---

## 6. Deployment Workflow

### Step 1: Launch DB VM
- When using **User Data**, the `%` wildcard in the MySQL GRANT statement allows the app to connect without needing the database IP in advance, since both servers launch automatically.  
- If **not using User Data**, simply replace the placeholder in the app script with the **public IP of the DB VM** before running it manually.  
- Allow inbound **HTTP (80)**, **application traffic (5000)**, and **SSH (22)**.  
- Once launched, the app will automatically connect to the database and serve content through **Nginx**, which proxies requests from port **80 → 5000**.

### Step 2: Launch the Application VM
- Update the `DATABASE_IP` variable in the app script with the **DB VM’s public IP** (if not using `%` wildcard for user data).  
- Use the app Bash script in **User Data** for this instance.  
- Allow inbound **HTTP (80)**, **application traffic (5000)**, and **SSH (22)**.  
- Once launched, the app will automatically connect to the database and serve content through **Nginx**, which proxies requests from port **80 → 5000**.

### Step 3: Access the Application
Open a web browser and navigate to:

`http://<app-public-ip>`

If successful, the application home page or the API endpoint will appear.

Check the Nginx access logs or app.log for troubleshooting if not.

---

## 7. Common Issues / Things to Be Aware Of

| Issue | Likely Cause | Explanation, Checks & Resolution |
|-------|---------------|----------------------------------|
| **App exits immediately after running** | The Spring Boot app cannot connect to the database, so it shuts down after startup. | This often occurs if the database is not active or the connection details are incorrect. <br><br>**Check:** <br>- Run `sudo systemctl status mysql` on the DB VM — it should show `active (running)`. <br>- Run `telnet <db-ip> 3306` from the app VM — if connected, MySQL is reachable. <br>- Confirm that the app log (`app.log`) shows a successful connection rather than `Connection refused`. <br><br>**Fix:** Ensure MySQL is running, the `bind-address` is set to `0.0.0.0`, and `DB_HOST` in the app matches the database’s public IP. |
| **Access denied for host when connecting to MySQL** | The MySQL server does not allow connections from the app VM’s IP. | By default, MySQL only accepts local connections (`localhost`). <br><br>**Check:** <br>- In the MySQL shell, run `SELECT host, user FROM mysql.user;` — the app VM’s IP or `%` should appear for `root`. <br>- Try connecting manually from the app VM with `mysql -u root -h <db-ip>` — this should succeed without “Access denied”. <br><br>**Fix:** Allow remote access by running the following in MySQL: <br>`CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';` <br>`GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;` <br>`FLUSH PRIVILEGES;` <br>Then restart MySQL with `sudo systemctl restart mysql`. |
| **Build fails unless using `-DskipTests`** | Maven runs tests that depend on local configurations or unavailable dependencies. | In automated environments, unit tests can fail if external resources (like databases) are not ready. <br><br>**Check:** <br>- Review the Maven output — failed test names appear near the end. <br>- Run `mvn clean install -DskipTests` manually to verify a successful build. <br><br>**Fix:** Use the flag `-DskipTests` in automation scripts to build without executing tests. This ensures the build completes even if test dependencies are missing, while tests can still be run locally during development. |

---

## Appendix

- **Appendix A:** [Database Provisioning Script](../bash-scripts/prov-db.sh) — Automates MySQL installation, remote access configuration, and database seeding.  
- **Appendix B:** [Application Provisioning Script](../bash-scripts/prov-app-reverse-proxy.sh) — Installs Java, Maven, and Nginx, builds the Spring Boot app, and deploys it behind a reverse proxy.






