# Sparta Node Sample App – Containerisation and Deployment Documentation  

- [Sparta Node Sample App – Containerisation and Deployment Documentation](#sparta-node-sample-app--containerisation-and-deployment-documentation)
  - [Overview](#overview)
  - [Stage 1: Containerising the Application](#stage-1-containerising-the-application)
    - [Dockerfile](#dockerfile)
      - [Purpose](#purpose)
      - [Breakdown](#breakdown)
    - [Building and Running the Container](#building-and-running-the-container)
    - [Pushing the Image to Docker Hub](#pushing-the-image-to-docker-hub)
    - [Pulling and Running the Image from Docker Hub](#pulling-and-running-the-image-from-docker-hub)
  - [Stage 1.5 – Introducing Docker Compose for Multi-Container Setup](#stage-15--introducing-docker-compose-for-multi-container-setup)
    - [docker-compose.yml](#docker-composeyml)
      - [Purpose](#purpose-1)
      - [Breakdown](#breakdown-1)
  - [Stage 2 – Reverse Proxy (Nginx)](#stage-2--reverse-proxy-nginx)
    - [docker-compose.yml](#docker-composeyml-1)
      - [Purpose](#purpose-2)
      - [Breakdown](#breakdown-2)
    - [nginx.conf](#nginxconf)
      - [Purpose](#purpose-3)
      - [Breakdown](#breakdown-3)
  - [Stage 3 – Database (MongoDB)](#stage-3--database-mongodb)
    - [.env File](#env-file)
      - [Purpose](#purpose-4)
      - [Breakdown](#breakdown-4)
    - [docker-compose.yml](#docker-composeyml-2)
      - [Purpose](#purpose-5)
      - [Breakdown](#breakdown-5)
  - [Stage 4 – Database Seeding](#stage-4--database-seeding)
    - [Purpose](#purpose-6)
    - [Step-by-Step Seeding Instructions](#step-by-step-seeding-instructions)

## Overview  

This documentation outlines the process of containerising the Sparta Node.js test application, running it in Docker, and extending it to use Docker Compose for managing multi-container environments. Each configuration file and command is explained clearly, describing what it does and why it is required.

---

## Stage 1: Containerising the Application 

The Sparta Node.js test app runs on Node v20 and serves three key pages:  
- Homepage (`localhost:3000`)  
- Blog posts page (`localhost:3000/posts`)  
- Fibonacci page (`localhost:3000/fibonacci/{index}`)  

The `/posts` route connects to a MongoDB database to display seeded data. Before seeding, this route appears blank with “Cannot GET /posts”, indicating the connection is successful but no data exists yet.

---

### Dockerfile

#### Purpose  

The Dockerfile defines how to build a container image for the Node.js app. It specifies the base image, working directory, dependencies, and startup commands.

#### Breakdown

```bash
FROM node:20  
LABEL description="Sparta test app container"  
WORKDIR /usr/src/app  
COPY app /usr/src/app  
COPY package*.json .  
RUN npm install  
EXPOSE 3000  
CMD ["node", "app.js"]  
```

**FROM node:20**  
- Specifies the base image to use for building the container.  
- Includes Node.js v20 and npm preinstalled.  
- Ensures the environment matches the version required by the Sparta app.

**LABEL description="Sparta test app container"**  
- Adds metadata to the container image.  
- Useful for documentation, identification, and management within registries.

**WORKDIR /usr/src/app**  
- Sets the default working directory for the container.  
- Any subsequent commands (COPY, RUN, CMD) execute from this location.  
- Ensures consistent directory structure across environments.

**COPY app /usr/src/app**  
- Copies the local `app` folder into the container.  
- The `app` directory contains the main application files (routes, views, logic).

**COPY package*.json .**  
- Copies both `package.json` and `package-lock.json` files.  
- Used by npm to install all project dependencies.  
- Placing this before `npm install` allows Docker to cache dependencies if the code changes later.

**RUN npm install**  
- Installs dependencies listed in `package.json`.  
- Runs inside the container image during build time.

**EXPOSE 3000**  
- Declares that the container listens on port 3000.  
- This does not publish the port outside the container; it is only a declaration for documentation and internal use.

**CMD ["node", "app.js"]**  
- Defines the default command executed when the container starts.  
- Runs the app directly with Node instead of using `npm start`.  
- Running Node directly ensures that system signals (like SIGTERM) are passed correctly to the process, allowing proper shutdowns.  
- Using `npm start` would prevent Docker and Kubernetes from sending termination signals to Node, potentially leaving connections open.

---

### Building and Running the Container

To create and run the containerised application:

1. Build the image  
   
```bash
docker build -t sparta-test-app .
```

2. Run the container and publish port 3000 

```bash 
docker run -d -p 3000:3000 --name sparta-app sparta-test-app:latest  
```

3. Confirm the container is running  

```bash
docker ps  
```

If the output shows a port mapping such as `0.0.0.0:3000->3000/tcp`, the application is accessible in a web browser at `http://localhost:3000`.

![Successful Sparta App Front Page](../../images/sparta-app-front-page.png)

---

### Pushing the Image to Docker Hub

Once tested locally, the image can be uploaded to Docker Hub to allow reuse or deployment elsewhere.

1. Log in to Docker Hub  

```bash
   docker login  
```

2. Tag the local image with the Docker Hub username and repository name 

```bash 
   docker tag sparta-test-app <docker-username>/sparta-test-app:latest  
```

3. Push the image to Docker Hub  

```bash
   docker push <docker-username>/sparta-test-app:latest  
```

4. Verify the upload
   Check the repository page on Docker Hub under **Tags** to confirm the image has been published.

---

### Pulling and Running the Image from Docker Hub

To ensure the uploaded image works correctly and to test the full deployment process, pull a fresh copy from Docker Hub and run it again.

1. Stop the existing container running on port 3000

```bash  
   docker stop sparta-app  
```

2. Pull the latest version of the image 

```bash 
   docker pull <docker-username>/sparta-test-app:latest  
```

3. Run the image from Docker Hub  

```bash
   docker run -d -p 3000:3000 <docker-username>/sparta-test-app:latest  
```

This confirms that the remote image runs independently of the local build and that the deployment process is complete.

---

## Stage 1.5 – Introducing Docker Compose for Multi-Container Setup

Before adding Nginx and MongoDB, Docker Compose can already be used to manage the Node.js container.  
This section introduces the Compose configuration before expanding it to include other services in later stages.

---

### docker-compose.yml

#### Purpose  

The Node.js service defines how the Sparta app runs within Docker Compose.  

It builds from the local Dockerfile, sets up environment variables, and establishes dependency order with the MongoDB container.

#### Breakdown

```yml
  nodejs:  
    build:  
      context: .  
      dockerfile: Dockerfile  
    image: chrleybolton/sparta-test-app:latest  
    container_name: nodejs  
    restart: unless-stopped  
    env_file: ./.env  
    ports:  
      - "3000:3000"  
    depends_on:  
      - mongodb  
```

**nodejs:**  
- Defines a service named `nodejs`, which represents the Sparta Node.js application.  
- This service will build and run the app inside a container, using the Dockerfile from Stage 1.

**build:**  
- Contains build instructions used by Docker Compose when no prebuilt image is available.

  - **context: .**  
    - Specifies the build context directory.  
    - The dot (`.`) means the current working directory, which contains the Dockerfile and application files.  
    - Everything inside this directory is available to the Docker build process.

  - **dockerfile: Dockerfile**  
    - Explicitly states which Dockerfile to use for the build.  
    - This is useful when multiple Dockerfiles exist or when naming conventions differ.

**image: chrleybolton/sparta-test-app:latest**  
- Defines the image name and tag that will be created and optionally pushed to Docker Hub.  
- Ensures consistency between local builds and remote deployment environments.

**container_name: nodejs**  
- Assigns a fixed name to the running container.  
- Makes it easier to identify and connect to the container using Docker CLI commands (e.g., `docker exec -it nodejs bash`).

**restart: unless-stopped**  
- Automatically restarts the container if it stops unexpectedly (e.g., crash, reboot).  
- The container will only remain stopped if manually stopped by the user.

**env_file: ./.env**  
- Loads environment variables from the `.env` file in the project root directory.  
- These variables define connection credentials and hostnames for the MongoDB database.  
- This method centralises configuration and prevents hardcoding sensitive information inside the yml file.

**ports:**  
  - **"3000:3000"**  
    - Maps port 3000 on the host machine to port 3000 inside the container.  
    - The left side (`3000`) refers to the local host port, and the right side (`3000`) refers to the container’s internal port.  
    - This allows users to access the application in a browser at `http://localhost:3000`.

**depends_on:**  
  - **mongodb**  
    - Ensures the MongoDB container starts before the Node.js container.  
    - This prevents the app from attempting to connect to the database before it is ready.  
    - Note: `depends_on` controls start order but does not verify readiness; health checks would be needed for that in production.

--- 

## Stage 2 – Reverse Proxy (Nginx)

### docker-compose.yml

#### Purpose

The Nginx container handles incoming HTTP requests and routes them to the Node.js application container.  

It listens on port 80 and uses a mounted configuration file to define its proxy rules.

Running Nginx as a reverse proxy allows users to access the application through standard web port 80 instead of the Node.js port (3000).

It also prepares the setup for production-style routing and future load balancing.

#### Breakdown

```bash
  nginx:  
    image: nginx:latest  
    container_name: nginx_container  
    ports:  
      - 80:80  
    volumes:  
      - ./nginx.conf:/etc/nginx/conf.d/default.conf  
    depends_on:  
      - nodejs  
```

**nginx:**  
- Declares a service called `nginx`, representing the reverse proxy server.  
- This service enables users to access the application through standard web port 80 instead of port 3000.

**image: nginx:latest**  
- Pulls the latest version of the official Nginx image from Docker Hub.  
- Provides a lightweight, production-grade web server optimised for performance.

**container_name: nginx_container**  
- Assigns a fixed name to the running Nginx container for easy identification and management.

**ports:**  
  - **80:80**  
    - Maps port 80 on the host machine to port 80 inside the Nginx container.  
    - Port 80 is the default for HTTP traffic, allowing users to visit the site without specifying a port (i.e., `http://localhost`).  
    - Requests hitting port 80 are processed by Nginx and then proxied to the Node.js service.

**volumes:**  
  - **./nginx.conf:/etc/nginx/conf.d/default.conf**  
    - Mounts the local `nginx.conf` configuration file into the container, replacing Nginx’s default configuration.  
    - The left side (`./nginx.conf`) is the host file path, while the right side (`/etc/nginx/conf.d/default.conf`) is the file location inside the container where Nginx expects its configuration.  
    - This bind mount ensures that any edits made to `nginx.conf` locally are reflected immediately inside the container.  
    - This is a common source of errors if the file path or formatting is incorrect. Always verify that the configuration file exists in the correct relative directory.

**depends_on:**  
  - **nodejs**  
    - Specifies that the Node.js service must start before Nginx.  
    - Prevents the proxy from starting before the backend application is ready.  

---

### nginx.conf

#### Purpose

The `nginx.conf` file defines how incoming HTTP requests are handled and where they should be sent. 

This configuration provides the routing logic required for Nginx to forward requests from port 80 to the Node.js service inside Docker’s internal network.

#### Breakdown

```bash
server {  
    listen 80;  
    location / {  
       proxy_pass http://nodejs:3000;  
    }  
}
```

**server { }**  
- Declares a server block containing configuration for a single virtual host.  
- This defines how Nginx will handle incoming connections.

**listen 80;**  
- Tells Nginx to listen for requests on port 80.  
- Port 80 is the default for unencrypted HTTP traffic.

**location /**  
- Defines a location block that matches all requests sent to `/`.  
- This is a catch-all route for all paths handled by the Node.js application.

**proxy_pass http://nodejs:3000;**  
- Specifies that all traffic received by Nginx should be forwarded to the Node.js container running on port 3000.  
- The hostname `nodejs` corresponds to the service name defined in Docker Compose, enabling communication over Docker’s internal network.  
- This removes the need for IP-based routing and allows containers to communicate dynamically.

---

## Stage 3 – Database (MongoDB)

The MongoDB container stores all persistent data for the application.  

It runs independently but is networked with the Node.js container through Docker Compose.

### .env File

#### Purpose

The `.env` file stores configuration variables required for the Node.js and MongoDB containers to connect correctly.  

It centralises configuration to avoid hardcoding credentials and environment-specific values in the source code.  
Docker Compose reads this file automatically whenever `env_file: ./.env` is defined in a service.

If MongoDB is running in authentication mode, credentials are required.

The values can be anything, but they must match the credentials created inside the MongoDB instance (for example, when seeding the DB or setting up user roles).

In a local development environment, simple placeholders like root / example are common.

In production, these should be replaced with strong, secret credentials (often stored securely via AWS Secrets Manager or Docker secrets).


```bash
DB_USER=root  
DB_PASSWORD=example  
DB_DATABASE=sparta  
DB_DOCKER_PORT=27017  
DB_HOST=mongodb://mongodb:27017/sparta  
```

#### Breakdown

- **DB_USER=root** – The username used to authenticate with MongoDB.  
- **DB_PASSWORD=example** – The password for that database user.  
- **DB_DATABASE=sparta** – The name of the database the Node.js app interacts with.  
- **DB_DOCKER_PORT=27017** – MongoDB’s default internal port.  
- **DB_HOST=mongodb://mongodb:27017/sparta** – The full connection string:  
  - `mongodb://` – specifies the MongoDB protocol.  
  - `mongodb` – the service name defined in the Compose file, used as the hostname.  
  - `27017` – the internal port exposed by the database container.  
  - `/sparta` – the name of the specific database to use.

The .env file should be created in the same directory as the docker-compose.yml file so Docker Compose can automatically detect and load it.

---

### docker-compose.yml

#### Purpose

This configuration ensures that MongoDB operates as an isolated, persistent data layer.  
The Node.js service connects to it using environment variables, while Docker Compose handles container networking automatically.  

Data remains intact through volume persistence, and the `.env` file simplifies secure configuration management.

```yml
  mongodb:  
    image: mongo:latest  
    container_name: mongodb_container  
    restart: unless-stopped  
    env_file: ./.env  
    ports:  
      - '27017:27017'  
    volumes:  
      - mongo-data:/data/db  

volumes:  
  mongo-data:  
```

#### Breakdown

**mongodb:**  
- Defines a service for running MongoDB as a separate container.  
- Acts as the database backend for the Node.js application.

**image: mongo:latest**  
- Pulls the latest official MongoDB image from Docker Hub.  
- Provides a fully configured MongoDB instance without requiring manual installation.

**container_name: mongodb_container**  
- Assigns a human-readable name to the MongoDB container.  
- Useful for debugging and for connecting via CLI commands.

**restart: unless-stopped**  
- Automatically restarts the container if it crashes or if the system reboots.  
- Keeps the database running reliably during development or testing.

**env_file: ./.env**  
- Loads database credentials and settings from the `.env` file.  
- Ensures consistency between the app and database configuration.

**ports:**  
  - **'27017:27017'**  
    - Maps port 27017 on the host to the same port inside the container.  
    - Enables local database management tools (e.g., MongoDB Compass) to connect to the container directly for inspection or manual testing.

**volumes:**  
  - **mongo-data:/data/db**  
    - Creates a persistent named volume called `mongo-data`.  
    - Mounts it to MongoDB’s default storage directory `/data/db` inside the container.  
    - This ensures that database data persists even if the container is removed or rebuilt.  
    - Volumes are managed by Docker and stored outside the container’s ephemeral filesystem.

**volumes:**  
  - **mongo-data:**  
    - Declares the named volume used above.  
    - Docker will automatically create and manage it if it does not already exist.  
    - Named volumes prevent data loss between container rebuilds.

---

## Stage 4 – Database Seeding

Once the Node.js and MongoDB containers are running, the database must be seeded with initial data.  

The `/posts` route in the Sparta Node app depends on this seed data. Without it, visiting `/posts` displays either a blank page or the message “Cannot GET /posts,” which confirms that the route exists but the database is currently empty.

---

### Purpose

Seeding populates the MongoDB database with sample data used by the application’s routes and tests. 

In this project, a seed script (`app/seeds/seed.js`) inserts predefined records into the `sparta` database.  
Seeding ensures that the `/posts` endpoint can return meaningful content and allows tests for the `/posts` route to pass successfully.

---

### Step-by-Step Seeding Instructions

**1. Verify that all containers are running**

Ensure the Node.js and MongoDB containers are active and connected within the same Docker network:

```bash
   docker ps
```

Expected containers:
- `nginx_container`
- `nodejs`
- `mongodb_container`

If any container is missing, start them again:

```bash
   docker compose up -d
```

---

**2. Access the Node.js container**

To run the seed script, access the Node.js container’s shell environment:

```bash
   docker exec -it nodejs bash
```

**3. Run the seed script**

Execute the following command within the Node.js container shell:

```bash
   node app/seeds/seed.js
```

**Explanation:**
- `node` runs a JavaScript file using the Node.js runtime inside the container.
- `app/seeds/seed.js` is the path to the seed script.
- The script connects to the MongoDB container using the environment variables from `.env` (specifically `DB_HOST`), then populates the database with predefined test data.

If the connection and credentials are correct, the terminal will display messages confirming that data has been successfully inserted into the `sparta` database.

---

**4. Confirm successful seeding**

After running the script:
- Exit the container shell by typing `exit`.  
- Refresh `http://localhost/posts` in a web browser.

If the seeding was successful, the `/posts` page will now display a list of post entries instead of being blank.

![Successful Sparta App Posts Page](../../images/sparta-app-posts-page.png)

---

**5. Troubleshooting**

If the seed command fails:
- Confirm the MongoDB container is running:  
  `docker ps | grep mongodb_container`
- Check the `.env` file for correct database credentials and host name.
- Confirm the connection string in `DB_HOST` matches the Compose service name (`mongodb`).
- Restart the containers:  
  `docker compose down` then `docker compose up -d`
- Retry seeding once services are stable.

