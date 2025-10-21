# Docker

- [Docker](#docker)
  - [Monolithic vs. Microservices Architecture](#monolithic-vs-microservices-architecture)
    - [Monolithic Architectures](#monolithic-architectures)
    - [Microservices Architecture](#microservices-architecture)
  - [Containers](#containers)
  - [Docker](#docker-1)
    - [Why Use Docker](#why-use-docker)
  - [Docker Architecture](#docker-architecture)
    - [Example: Running a Container](#example-running-a-container)
  - [How Docker Works](#how-docker-works)
  - [Downloading Docker Desktop](#downloading-docker-desktop)
  - [Downloading Docker Desktop](#downloading-docker-desktop-1)
    - [Installation and Account Setup](#installation-and-account-setup)
  - [Container Basics](#container-basics)
    - [Viewing and Managing Containers in Docker Desktop](#viewing-and-managing-containers-in-docker-desktop)
    - [Understanding Container Images](#understanding-container-images)
    - [Creating a Simple Custom Image](#creating-a-simple-custom-image)
      - [Without a Dockerfile](#without-a-dockerfile)
      - [With a Dockerfile](#with-a-dockerfile)
    - [Removing a Container](#removing-a-container)
  - [Customising Nginx Containers](#customising-nginx-containers)
    - [1. Manual Edits Inside a Running Container](#1-manual-edits-inside-a-running-container)
    - [2. Using Docker Desktop](#2-using-docker-desktop)
    - [3. Using a Dockerfile (Reusable \& Recommended)](#3-using-a-dockerfile-reusable--recommended)
  - [Further Examples of Container on Different Ports](#further-examples-of-container-on-different-ports)
  - [Hosting Custom Images on Docker Hub](#hosting-custom-images-on-docker-hub)
    - [Why Use Docker Hub](#why-use-docker-hub)
    - [Preparing a Custom Image](#preparing-a-custom-image)
    - [Creating a Repository on Docker Hub](#creating-a-repository-on-docker-hub)
    - [Logging In via Terminal](#logging-in-via-terminal)
    - [Tagging the Local Image](#tagging-the-local-image)
    - [Pushing the Image to Docker Hub](#pushing-the-image-to-docker-hub)
    - [Verifying the Upload](#verifying-the-upload)

## Monolithic vs. Microservices Architecture

### Monolithic Architectures

In a **monolithic architecture**, all parts of an application — such as the user interface, business logic, and data access layer — are built and deployed as one single, tightly connected unit.  
If one part of the system experiences an issue or high demand, the entire application must be scaled or redeployed as a whole.  

This can make development slower, updates more risky, and scaling inefficient.

**Key Characteristics:**
- A single codebase containing all application logic.  
- All features are deployed together as one package.  
- Components are tightly coupled, so changes in one area can affect others.  
- A single point of failure can bring down the entire system.

**Drawbacks:**
- Difficult to scale specific parts of the application independently.  
- Slower release cycles as one small change requires redeploying everything.  
- Harder for large teams to work simultaneously without conflicts.  
- Failures in one part can impact the whole system.

---

### Microservices Architecture

A **microservices architecture** breaks an application into smaller, independent services. Each service focuses on a single business function (for example: payments, authentication, or user management).  

Each microservice can be developed, tested, deployed, and scaled independently. The services communicate using lightweight APIs, such as REST or message queues.

Microservices are commonly deployed in **containers**, as containers provide the perfect environment for running independent services. Each service can live inside its own isolated container, making the overall system more reliable and flexible.

**Key Characteristics:**
- Each service performs one specific function.  
- Services are independently deployable and maintainable.  
- Communication happens through well-defined interfaces (usually HTTP APIs).  
- Teams can build and deploy services separately using different technologies.

**Benefits:**
- **Agility:** Faster development cycles and independent releases.  
- **Scalability:** Scale individual services rather than the whole system.  
- **Resilience:** If one service fails, others continue running.  
- **Flexibility:** Different technologies can be used for different services.  
- **Efficiency:** Reusable, modular components reduce duplicated work.  
- **Ease of Deployment:** Supports continuous integration and delivery (CI/CD).  

Microservices define *how* an application is structured — as small, self-contained units. Containers define *how* those units are run — in lightweight, isolated environments that behave consistently across different systems.

---

## Containers

A **container** is a lightweight, standalone package that includes everything needed to run an application: the code, dependencies, libraries, and configuration files.  

Containers run on top of an existing operating system but remain fully isolated from one another using features of the Linux kernel (such as **namespaces** and **control groups**).  

This isolation allows multiple containers to run on the same machine without interfering with each other. They start quickly, use fewer resources than virtual machines, and can be moved easily between environments.

**How Containers Support Microservices:**  
In a microservices system, each service can be placed in its own container. This ensures consistent behaviour across environments and allows each service to be deployed, tested, and scaled independently. Containers help maintain stability as systems grow in size and complexity.

**Key Features of Containers**

1. **Portability**  
   Containers ensure that applications run the same way everywhere — whether on a developer’s laptop, a test server, or in the cloud.  
   > Example: A web application built in Linux can run seamlessly on Windows or macOS using Docker containers.

2. **Isolation**  
   Each container runs in its own isolated environment, keeping its processes and data separate from other containers and the host system.

3. **Efficiency**  
   Containers share the host operating system’s kernel, making them faster and more lightweight than traditional virtual machines.  
   This allows for higher density — running more containers on the same hardware.

4. **Consistency**  
   Containers eliminate the “works on my machine” problem by providing a predictable and repeatable runtime environment for applications.

5. **Scalability**  
   Containers can be started, stopped, replicated, or removed quickly. This allows applications to handle varying levels of demand efficiently.

Containers define *how* modern applications are executed — providing the flexibility and reliability needed to build scalable, distributed systems.

---

## Docker

**Docker** is a platform that simplifies the process of building, running, and managing containers.  
It provides a consistent way to package applications and their dependencies into **images**, store them in **registries**, and run them as **containers** on any system that has Docker installed.

While containerisation existed before Docker, it was complex to implement manually. Docker made containers accessible to everyone by introducing simple commands, automation, and standardised formats.

**How Docker Relates to Containers:**  
Containers are the underlying technology. Docker is the ecosystem that makes them easy to use — providing tools, commands, and a standard way to build and manage them.  
Docker makes containerisation *practical, portable, and efficient*, forming a core part of modern development workflows.

**Docker Workflow Overview**
1. **Build:** Create an image from a `Dockerfile`, which defines everything needed to run the application.  
2. **Ship:** Push the image to a registry (e.g. Docker Hub) for distribution.  
3. **Run:** Pull the image and start containers on any machine with Docker installed.  

This approach ensures that applications behave identically across development, testing, and production environments.

---

### Why Use Docker

1. **Fast, Consistent Delivery**  
   Docker enables developers to work in identical environments, reducing bugs caused by system differences.  
   It fits seamlessly into CI/CD pipelines for automated testing and deployment.

2. **Scalability and Flexibility**  
   Docker containers can be deployed on laptops, servers, or cloud environments with minimal setup.  
   Applications can scale up or down instantly by running more or fewer containers.

3. **Resource Efficiency**  
   Containers are lightweight, using fewer resources than virtual machines.  
   More containers can run on the same hardware, reducing costs and improving utilisation.

4. **Simplified Collaboration**  
   Teams can share images through Docker Hub or private registries, ensuring consistent builds and predictable deployments.

Docker provides the foundation that makes containerisation standardised, reliable, and easy to implement across all environments.

---

## Docker Architecture

Docker operates on a **client–server model**, consisting of three main components that work together:

1. **Docker Client (`docker`)**  
   - The command-line interface that developers use to interact with Docker.  
   - Sends commands like `docker run` or `docker build` to the Docker daemon.  
   - Communicates via the Docker API and can connect to local or remote servers.

2. **Docker Daemon (`dockerd`)**  
   - The background service that manages containers, images, networks, and volumes.  
   - Handles tasks such as building images, starting containers, and maintaining system state.  
   - Can communicate with other daemons to manage distributed services across multiple hosts.

3. **Docker Registries**  
   - Repositories where images are stored and shared.  
   - **Docker Hub** is the default public registry, but private registries are also supported.  
   - Commands like `docker pull` download images, and `docker push` uploads them.

4. **Docker Objects**  
   - **Images:** Templates that define how containers are built and configured.  
   - **Containers:** Running instances of images.  
   - **Networks:** Define communication between containers.  
   - **Volumes:** Provide persistent data storage beyond a container’s lifecycle.

Docker’s client–server design allows developers to run containers locally or remotely with the same commands, simplifying both development and deployment.

---

### Example: Running a Container

1. Docker checks if the `ubuntu` image exists locally. If not, it downloads it from **Docker Hub**, a central image repository.  
2. A new container is created from that image — a live instance of the predefined template.  
3. Docker allocates a writable filesystem layer on top of the image, allowing changes during runtime.  
4. A virtual network interface connects the container to the host system.  
5. The command `/bin/bash` starts an interactive shell session inside the container.  
6. When the `exit` command is used, the container stops but remains stored on the system until manually removed.

This process demonstrates how Docker standardises container creation and execution across all environments.

---

## How Docker Works

Docker is written in **Go** and uses several core **Linux kernel features** to create and manage containers efficiently:

- **Namespaces:**  
  Create isolated environments, ensuring that processes, networks, and mounts within one container cannot interact with others.  

- **Control Groups (cgroups):**  
  Manage and limit system resources such as CPU, memory, and disk I/O for each container.  
  This prevents a single container from overusing resources and affecting others.

- **Union File Systems (UnionFS):**  
  Combine multiple read-only and writable filesystem layers into a single unified view.  
  Each layer represents part of the container’s state, making image creation and updates lightweight and efficient.

- **Container Format:**  
  Defines a consistent package that bundles these technologies, ensuring containers behave predictably across systems.

These technologies together make containers lightweight, secure, and fast. Multiple containers can run on the same host machine, each isolated but sharing system resources efficiently.


## Downloading Docker Desktop 

## Downloading Docker Desktop

**Docker Desktop** is an easy-to-install application that provides a complete environment for building, running, and managing containers on macOS, Windows, and Linux. 
 
It includes all the core Docker components — the **Docker Engine**, **Docker CLI**, **Docker Compose**, and a visual dashboard for managing images, containers, networks, and volumes.

Docker Desktop simplifies local container development by allowing images to be pulled, built, and run through either the command line or the graphical interface. It is the recommended tool for learning and developing with Docker.

### Installation and Account Setup

Before downloading, a **Docker account** is required.  
A free account can be created at [https://hub.docker.com/signup](https://hub.docker.com/signup).  

This account allows access to **Docker Hub**, where official images are hosted and personal images can be stored or shared.

Once an account is created, install Docker Desktop by following the official guides:

- [Install Docker Desktop on Windows](https://docs.docker.com/desktop/setup/install/windows-install/)  
- [Install Docker Desktop on macOS](https://docs.docker.com/desktop/setup/install/mac-install/)

After installation, sign in to Docker Desktop using the Docker Hub account credentials.  

When the **Docker whale icon** appears in the system tray or menu bar, Docker Desktop is running and ready to manage images and containers.

## Container Basics

### Viewing and Managing Containers in Docker Desktop

In the container tab:

![Docker Container Tab](../images/docker-container-tab.png)

- **Starting a Container:**  
  Once a container has been created or stopped, it can be restarted directly in Docker Desktop.  
  To do this, select the container under the **Containers** tab and click the **Play** (▶) button.  
  This action starts the container again using its previous configuration, including assigned ports, environment variables, and mounted volumes.  
  When running, the container becomes active and ready to serve applications or content immediately.

- **Viewing a Running Container:**  
  Select the **port number** shown in Docker Desktop to open the running container in a browser.  
  This allows verification that the container is active and serving the expected content.

- **Inspecting Container Files:**  
  Select the **container name** in Docker Desktop to view its internal file system, configuration, and logs.

- **Stopping a Container:**  
  Use the **Stop** button in Docker Desktop to safely stop a running container without deleting it.  
  Containers can later be restarted or removed as needed.

### Understanding Container Images

A **container image** is a standardised, pre-packaged environment that includes all the files, binaries, libraries, and configurations required to run a container.  

It acts as a **blueprint** for creating one or more containers — each container being a running instance of that image.

Examples:
- A **PostgreSQL image** includes the database binaries, configuration files, and dependencies.  
- A **Python application image** includes the Python runtime, application code, and required packages.

**Key Principles of Images:**

1. **Immutability:**  
   Once created, an image cannot be modified. Any change requires creating a new image or adding a new layer on top of the existing one.

2. **Layered Structure:**  
   Images consist of multiple layers, each representing changes to the filesystem (for example, adding or removing files).  

   These layers stack together to form the final image, improving efficiency and allowing shared base layers between images.

![Docker Image Layers](../images/docker-image-layers.png)

* This example  is just one possible stack — a Python-based application image.*

This layered structure allows extension of existing images. For instance, a custom application can start from a base image such as `python` or `nginx` and add only the necessary dependencies and application files.  

This approach keeps builds lightweight, modular, and focused on the application rather than the underlying system.

---

### Creating a Simple Custom Image

A new image can be created in two main ways — **with** or **without** a Dockerfile.

---

#### Without a Dockerfile

An image can be customised directly from an existing one without writing a Dockerfile.  

For example, the official **Nginx** image can serve local files by linking a local directory to the container:

```bash
docker run --name some-nginx -d -p 8080:80 -v /path/to/local-folder:/usr/share/nginx/html nginx
```

This command:
- Uses the official **nginx** image.  
- Runs it in the background (`-d`).  
- Maps port **8080** on the host machine to port **80** in the container.  
- Uses **-v** to share a local folder with the container, allowing Nginx to serve files from that directory.

This approach is useful for quick testing or demos. However, any changes made are temporary — removing the container deletes its configuration.  

For consistent and repeatable setups, a Dockerfile should be used.

---

#### With a Dockerfile

![Dockerfile Symbol](../images/dockerfile-symbol.png)

A **Dockerfile** defines how an image should be built. It specifies a base image, adds files, and lists commands to run during the build process.  

This method is ideal for reusable and version-controlled environments.

**Within the Dockerfile:**

```bash
FROM nginx  
COPY static-html-directory /usr/share/nginx/html
```

*Note: the nginx base image used in this Dockerfile is pulled from Docker Hub.* 

- **FROM nginx**  
  Uses the official Nginx image as the starting point, which already includes a fully configured web server and a default “Welcome to nginx!” homepage.

- **COPY static-html-directory /usr/share/nginx/html**  
  Copies all local web files from a folder named `static-html-directory` into Nginx’s default web directory inside the container.  
  If this folder is empty or doesn’t exist, Docker still builds the image successfully — Nginx simply continues to serve its built-in default homepage.

This means the Dockerfile works even without adding any custom files, but if `static-html-directory` contains a custom `index.html` or other assets, they will replace Nginx’s default content when the image is built.

---

**Build and run the container**

```bash
docker build -t some-content-nginx .  
docker run --name some-nginx -d -p 8080:80 some-content-nginx
```

- **-t some-content-nginx**  
  Tags (names) the new image for easier reference.  
- **--name some-nginx**  
  Assigns a readable name to the container instance.  
- **-d**  
  Runs the container in detached mode (in the background).  
- **-p 8080:80**  
  Maps port 8080 on the host to port 80 inside the container so the site can be viewed at localhost:8080.

If a container is run directly from the base `nginx` image, it still appears in Docker Desktop, but no new image is created.  

Using a Dockerfile ensures a **reusable, consistent build** that can include custom static content when needed.

---

### Removing a Container

1. **List containers** to find the name or ID:  
   docker ps -a  

2. **Stop the container** if it’s still running:  
   docker stop <container-name>  

3. **Remove the container:**  
   docker container rm <container-name>  

Alternatively, use Docker Desktop:  
- Open the **Containers** tab.  
- Stop the container if needed.  
- Click the **Delete (🗑️)** icon to remove it.

---

## Customising Nginx Containers

Nginx containers can be customised in several ways depending on what’s needed.  

![Original Nginx Homepage](../images/original-nginx-homepage.png)

The three most common beginner-friendly methods are:

---

### 1. Manual Edits Inside a Running Container

Used for quick testing or learning how containers work.

**From local:**

- Copy the image into the container:

```bash  
  docker cp /path/to/local/image.jpg <container-name>:/usr/share/nginx/html  
```

**Access the container shell:**

```bash
docker exec -it <container-name> /bin/bash
```

**Inside the container:**
- Navigate to the web directory:  

```bash
cd /usr/share/nginx/html` 
```

- View the html file:

```bash
  `cat index.html`
```

- Edit the HTML file inside the container:
  ```bash  
  sed -i '/<p><em>Thank you for using nginx.<\/em><\/p>/a <img src="image.jpg" alt="text that explains what the image is">' /usr/share/nginx/html/index.html  
  ```

![Nginx Modified Homepage with Rabbit Image](../images/nginx-homepage-edit-1.png)

These changes disappear when the container is removed — useful for experimentation, not production.

---
### 2. Using Docker Desktop

A practical visual method for inspecting or making quick edits.

- Open the container in **Docker Desktop**.  
- Select the container name and open the **Files** tab to browse to `/usr/share/nginx/html`.  

![Docker File Access](../images/docker-file.png)

The **Files** tab allows editing and deleting existing files, but does not support drag-and-drop uploads so the image will need to be copied using the command above. 

- Edit `index.html` within the editor & save.

![Edit Screen for Docker Desktop](../images/edit-screen-docker-desktop.png)
 
- Restart the container to apply changes.  

This method is suitable for visual exploration and verifying file behaviour inside a running container.

![Nginx Modified Homepage with Capybara Image](../images/nginx-homepage-edit-2.png)

---

### 3. Using a Dockerfile (Reusable & Recommended)

For consistent, reusable customisation.

**Dockerfile example:**

```bash
FROM nginx  
COPY static-html-directory /usr/share/nginx/html  
COPY docker_poppy.jpg /usr/share/nginx/html/
```

*Note The image file (docker_poppy.jpg) must be located in the same directory as the Dockerfile, since Docker copies files relative to the build context (the folder where the docker build command is run).*

**Explanation:**
- **FROM nginx** – starts from the official Nginx base image.  
- **COPY static-html-directory /usr/share/nginx/html** – replaces the default homepage with local files.  
- **COPY docker_poppy.jpg /usr/share/nginx/html/** – adds the image file.

**Project structure:**
project-folder/  
│  
├── Dockerfile  
├── docker_poppy.jpg  
└── static-html-directory/  
  └── index.html  

**Build and run:**

```bash
docker build -t some-content-nginx .  
docker run --name some-nginx -d -p 8080:80 some-content-nginx  
```

This ensures the custom homepage and image are always included whenever the image is rebuilt or shared.

![Nginx Modified Homepage with Dog Image](../images/nginx-homepage-edit-3.png)

## Further Examples of Container on Different Ports

**Apache (httpd):**

`docker run --name some-apache -d -p 8081:80 httpd`

![Apache HTTPD on Port 8081:80](../images/apache_httpd.png)

**Python Simple HTTP Server**

`docker run --name some-python -d -p 8082:8000 python:3.12-slim python -m http.server 8000`

![Python HTTP on Port 8082:80](../images/python-http.png)

## Hosting Custom Images on Docker Hub

Once a custom container image has been created locally, it can be shared publicly or privately through **Docker Hub**. Docker Hub acts as a central registry for storing and distributing container images, similar to how GitHub hosts code repositories. It allows developers and teams to publish, version, and share their containerised applications for others to download and run easily.  

Using Docker Hub provides a consistent way to distribute containerised environments across systems, ensuring that applications run identically in development, testing, and production environments.

---

### Why Use Docker Hub

- **Collaboration:** Share container images with teammates or the wider community.
- **Version Control:** Tag and manage different versions of the same image.
- **Reproducibility:** Ensure consistent environments across multiple machines.
- **Automation:** Integrate into CI/CD pipelines for seamless deployment.

Docker Hub can host both public and private repositories. Public repositories are accessible to everyone, while private ones restrict access to authorised users.

---

### Preparing a Custom Image

Before pushing an image to Docker Hub, ensure that a working container image has been built locally. This image should be based on a Dockerfile that automates the build process.

A typical example involves creating a simple static webpage hosted by Nginx:

**Project structure:**

project-folder/  
├── Dockerfile  
└── static-html-directory/  
  └── index.html  

**index.html:**

<html>  
  <head><title>Hello World</title></head>  
  <body>  
    <h1>Hello from my Docker container!</h1>  
  </body>  
</html>  

When this directory structure is used with the Dockerfile:

```BASH
FROM nginx  
COPY static-html-directory /usr/share/nginx/html  
```

and built using the standard `docker build` command, Nginx will serve the simple "Hello World" page instead of its default welcome screen.

After defining the Dockerfile, the image can be built locally. See previous steps for build and run commands.

![Example of Custom Container](../images/custom-docker-site.gif)

---

### Creating a Repository on Docker Hub

1. Visit **https://hub.docker.com/** and log in to your Docker account.  
2. Navigate to **Repositories → New Repository**.  
3. Enter a repository name (for example, `host-custom-static-webpage`).  
4. Set visibility to **Public** or **Private**.
5. Click **Create**.

This creates a remote repository ready to receive pushed images from the local machine.

---

### Logging In via Terminal

To authenticate the local Docker client with Docker Hub, use the `docker login` command.  

Enter the same username and password used to sign in to the website.  

A confirmation message stating “Login Succeeded” confirms successful authentication.

---

### Tagging the Local Image

Before pushing an image to Docker Hub, it must be tagged with the correct repository name and username.  

For example, if the Docker Hub username is `exampleuser` and the repository is named `host-custom-static-webpage`, the tag would be:

```bash
docker tag host-custom-static-webpage exampleuser/host-custom-static-webpage:latest
```

This assigns the image a full repository path that Docker Hub recognises.

---

### Pushing the Image to Docker Hub

Once tagged, the image can be uploaded using:

```bash
docker push exampleuser/host-custom-static-webpage:latest
```

Each image layer will upload sequentially. Once completed, the repository on Docker Hub will display the pushed tag (usually `latest`) and indicate the image is ready for public use.

---

### Verifying the Upload

To confirm the image was uploaded successfully:

1. Visit the repository page on Docker Hub.  
2. Check under the **Tags** tab for the uploaded image tag. 

! [Successful Upload of Image to DockerHub] (../images/successful-upload-of-image-to-dockerhub.png)

3. Optionally, test by pulling the image back down to the local machine and running it:

```bash
docker pull exampleuser/host-custom-static-webpage:latest  
docker run -d -p 8080:80 exampleuser/host-custom-static-webpage:latest  
```
If the container runs and displays the expected application, the upload was successful.

