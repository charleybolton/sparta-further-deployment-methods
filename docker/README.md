- [Docker Basics](#docker-basics)
  - [Monolithic vs. Microservices Architecture](#monolithic-vs-microservices-architecture)
    - [Monolithic Architectures](#monolithic-architectures)
    - [Microservices Architecture](#microservices-architecture)
  - [Containers](#containers)
    - [Containers vs. Virtual Machines](#containers-vs-virtual-machines)
      - [Key Differences](#key-differences)
      - [When to Use Each](#when-to-use-each)
      - [Benefits Summary](#benefits-summary)
  - [Docker](#docker)
    - [Why Use Docker](#why-use-docker)
    - [Docker Alternatives](#docker-alternatives)
    - [Docker Success Story: Spotify](#docker-success-story-spotify)
      - [Challenge](#challenge)
      - [Solution](#solution)
      - [Results / Benefits](#results--benefits)
  - [Docker Architecture](#docker-architecture)
    - [Example: Running a Container](#example-running-a-container)
  - [How Docker Works](#how-docker-works)
  - [Downloading Docker Desktop](#downloading-docker-desktop)
    - [Installation and Account Setup](#installation-and-account-setup)
  - [Container Basics](#container-basics)
    - [Viewing and Managing Containers in Docker Desktop](#viewing-and-managing-containers-in-docker-desktop)
    - [Understanding Container Images](#understanding-container-images)
    - [First Pull and Run: hello-world](#first-pull-and-run-hello-world)
    - [Creating a Simple Custom Image](#creating-a-simple-custom-image)
      - [Without a Dockerfile](#without-a-dockerfile)
      - [With a Dockerfile](#with-a-dockerfile)
    - [Removing a Container](#removing-a-container)
    - [Forcibly Removing a Running Container](#forcibly-removing-a-running-container)
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
    - [Creating an Image from a Running Container](#creating-an-image-from-a-running-container)
    - [Tagging the Local Image](#tagging-the-local-image)
    - [Pushing the Image to Docker Hub](#pushing-the-image-to-docker-hub)
    - [Verifying the Upload](#verifying-the-upload)
  - [Docker Compose](#docker-compose)
    - [Why Use Docker Compose?](#why-use-docker-compose)
    - [Common Use Cases](#common-use-cases)
  - [How to Use Docker Compose](#how-to-use-docker-compose)
    - [How to Install](#how-to-install)
    - [The Compose File](#the-compose-file)
    - [Starting and Stopping an Application](#starting-and-stopping-an-application)
    - [Managing Individual Services](#managing-individual-services)
    - [Running One-Time Commands](#running-one-time-commands)
    - [Running One-Time Commands](#running-one-time-commands-1)
    - [Viewing Container Information](#viewing-container-information)
- [Sparta Node Sample App – Containerisation and Deployment Documentation](#sparta-node-sample-app--containerisation-and-deployment-documentation)
  - [Overview](#overview)
  - [Stage 1: Containerising the Application](#stage-1-containerising-the-application)
    - [Dockerfile](#dockerfile)
      - [Purpose](#purpose)
      - [Breakdown](#breakdown)
    - [Building and Running the Container](#building-and-running-the-container)
    - [Pushing the Image to Docker Hub](#pushing-the-image-to-docker-hub-1)
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
    - [docker-compose.yml](#docker-composeyml-2)
      - [Purpose](#purpose-4)
      - [Breakdown](#breakdown-4)
    - [.env File](#env-file)
      - [Purpose](#purpose-5)
      - [Breakdown](#breakdown-5)
  - [Stage 4 – Database Seeding](#stage-4--database-seeding)
    - [Purpose](#purpose-6)
    - [Step-by-Step Seeding Instructions (Manual)](#step-by-step-seeding-instructions-manual)
    - [Automatic Seeding Methods](#automatic-seeding-methods)
    - [Updated Dockerfile](#updated-dockerfile)
    - [Updated docker-compose.yml](#updated-docker-composeyml)
    - [Why the Common Online Method Does Not Work](#why-the-common-online-method-does-not-work)
    - [Importance of Using `docker compose down -v`](#importance-of-using-docker-compose-down--v)
  - [Launching The App on an EC2 Instance](#launching-the-app-on-an-ec2-instance)

# Docker Basics

## Monolithic vs. Microservices Architecture

### Monolithic Architectures

In a **monolithic architecture**, all parts of an application — such as the user interface, business logic, and data access layer — are built and deployed as one single, tightly connected unit.  

If one part of the system experiences an issue or high demand, the entire application must be scaled or redeployed as a whole.  

This can make development slower, updates more risky, and scaling inefficient.

**Key Characteristics:**
- A single codebase containing all application logic.  
- All features are deployed together as one package.  
- Components are tightly coupled, so changes in one area can affect others.  

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

### Containers vs. Virtual Machines

Both **containers** and **virtual machines (VMs)** allow applications to run independently from underlying hardware — but they achieve this through different forms of virtualisation.

- **Virtual machines** replicate an entire computer system, including its own operating system (OS), kernel, and applications.  
- **Containers** virtualise only the operating system, isolating applications and their dependencies within lightweight environments that share the same host OS.

This distinction makes containers faster, smaller, and more portable — while VMs provide deeper isolation and full control over their own environments.

---

#### Key Differences

| Feature | **Containers** | **Virtual Machines** |
|:--|:--|:--|
| **Virtualisation Layer** | OS-level (shares host kernel). | Hardware-level (each has its own OS). |
| **Core Technology** | Uses a container engine (e.g. Docker) to manage isolated user spaces. | Uses a hypervisor (e.g. VMware, Hyper-V) to run multiple guest OSs. |
| **Size & Speed** | Lightweight, starts in seconds (MBs). | Heavier, boots in minutes (GBs). |
| **Isolation** | Process-level — ideal for running microservices. | Full OS isolation — ideal for running multiple environments. |
| **Portability** | Highly portable across environments. | Migration can be slower and more complex. |
| **Resource Usage** | Shares host OS resources efficiently. | Requires dedicated resources for each VM. |
| **Scalability** | Easily scaled and orchestrated (e.g. via Kubernetes). | Scaling is costlier and slower. |
| **Control** | Limited to container environment. | Full control over guest OS and configuration. |

---

#### When to Use Each

- **Use Containers** when you need lightweight, portable environments for **microservices**, **CI/CD pipelines**, or **cloud-native applications**.  
- **Use Virtual Machines** when you require full OS control for **legacy systems**, **testing across OSs**, or **stronger security isolation** between workloads.

---

#### Benefits Summary

| **Containers** | **Virtual Machines** |
|:--|:--|
| Portability across environments | Efficient use of physical hardware |
| Rapid deployment and iteration | Full control of OS and configuration |
| Lightweight and resource-efficient | Easier backup and disaster recovery |
| Ideal for microservices and scaling | Suitable for legacy and multi-OS workloads |

---

## Docker

**Docker** is a platform that simplifies the process of building, running, and managing containers.  
It provides a consistent way to package applications and their dependencies into **images**, store them in **registries**, and run them as **containers** on any system that has Docker installed.

While containerisation existed before Docker, it was complex to implement manually. Docker made containers accessible to everyone by introducing simple commands, automation, and standardised formats.

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

### Docker Alternatives

While Docker remains the industry standard for containerisation, several alternatives offer similar functionality with different levels of integration and support.

- **Podman** – Open-source, daemonless, and rootless by default, offering strong security but lacking Docker’s unified management and desktop tools.  
- **containerd** – A lightweight container runtime used by both Docker and Kubernetes; efficient but minimal, requiring extra tools for building and registry management.  
- **LXC/LXD** – System-level containers that emulate full operating systems; suitable for infrastructure use cases but less streamlined for developers.  
- **DIY OSS Stack** – Combining open-source tools can replicate Docker’s functionality but lacks central administration, integrated registries, and enterprise-grade security or support.

**Key Difference:**  

Docker Business delivers an integrated, enterprise-ready suite (Docker Desktop, Hub, Scout, Build Cloud, Testcontainers) that provides advanced security, policy management, and support out of the box — capabilities that alternatives require additional tools and maintenance to match.

---

### Docker Success Story: Spotify

**Company:** Spotify AB — a global music streaming platform serving hundreds of millions of users monthly.  
**Technology Focus:** Containers (via Docker) and orchestration (via Kubernetes) within a microservices architecture.

#### Challenge  
Spotify had already adopted microservices and containerised many services using Docker as early as 2014, running them across a fleet of virtual machines.  
However, managing and orchestrating thousands of containers became complex and costly when using its in-house tool, Helios.  

#### Solution  
- Migrated from Helios to Kubernetes while continuing to use Docker for containerisation.  
- Implemented Docker-based microservices that could be scaled, updated, and deployed more efficiently.  
- Leveraged Kubernetes to automate container scheduling, load balancing, and scaling across global infrastructure.  

#### Results / Benefits  
- Deployment times reduced from hours to minutes, significantly improving release speed.  
- Resource utilisation improved through more efficient scheduling and scaling.  
- Developer productivity increased as teams could focus on delivering new features rather than managing infrastructure.  
- The platform now runs over 1,600 production services, each independently containerised, maintaining reliability at massive scale.  

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

---

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

### First Pull and Run: hello-world

The hello-world image provides a simple way to verify that Docker has been installed correctly and is functioning as expected.  

It runs a small container that prints a confirmation message from inside the Docker environment, demonstrating the basic process of pulling, creating, and running containers.

When executed, Docker performs several steps automatically:

1. Checks whether the hello-world image already exists locally.  
2. If the image is missing, it downloads it from Docker Hub — the central repository for container images.  
3. Creates a new container from that image.  
4. Runs the container, which prints a short message confirming successful setup, then exits.

To get help from the docker command:

```bash
docker --help
```

To view existing local images: 

```bash
docker images  
```
To download and run the hello-world image:  

```bash
docker run hello-world  
```

Example output:

```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Running the hello-world image for the first time automatically pulls it from Docker Hub if it does not already exist locally. The command creates a container, displays a confirmation message, and then exits once complete.  

When the image is executed a second time, Docker does not perform another download because the image is already cached locally. The container starts instantly and produces the same output.  

**Behaviour comparison:**  
- *Image not present:* Docker retrieves the required layers from the registry before starting the container.  
- *Image present locally:* Docker skips the download process and launches the container immediately using the cached image.

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

To verify that the nginx container is running: 

```bash
docker ps  
```

This command lists all active containers along with their container ID, name, status, exposed ports, and associated image.  

If nginx is running correctly, its status will show as “Up” and the port mapping (for example, 0.0.0.0:80->80/tcp) will confirm that it is exposed on port 80 of the local machine.  

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

*Note: the Nginx base image used in this Dockerfile is pulled from Docker Hub.* 

- **FROM nginx**  
  Uses the official Nginx image as the starting point, which already includes a fully configured web server and a default “Welcome to nginx!” homepage.

- **COPY static-html-directory /usr/share/nginx/html**  
  Copies all local web files from a folder named `static-html-directory` into Nginx’s default web directory inside the container.  
  If this folder is empty or doesn’t exist, Docker still builds the image successfully — Nginx simply continues to serve its built-in default homepage.

This Dockerfile still works even without custom files. If `static-html-directory` contains a custom `index.html` or other assets, they’ll replace Nginx’s default content when built.

---

**Build and Run the Container**

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

If a container is run directly from the base Nginx image, it still appears in Docker Desktop, but no new image is created.  

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

### Forcibly Removing a Running Container

Attempting to remove a container while it is still running will return an error message similar to:

```bash
"Error response from daemon: You cannot remove a running container <container_id>. Stop the container before attempting removal or use the -f flag."
```

This confirms that Docker prevents the removal of active containers by default as a safeguard against accidental deletion.

To forcibly remove a running container without stopping it first: 

```bash
docker rm -f <container-name>
```

Using the -f (force) option stops the container and removes it in a single command.

To confirm that the container has been removed:  

```bash
docker ps -a  
```

The container should no longer appear in the list, indicating successful removal.

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

When running Docker on Windows through Git Bash, the terminal can sometimes struggle to run interactive programs properly because Git Bash does not use a full terminal environment (known as a TTY).  

A **TTY **is simply a text-based interface that lets commands receive input and show output in real time — for example, when opening an interactive shell like /bin/bash or editing a file with nano inside a container.  

Git Bash runs on top of a compatibility layer called MSYS2, which does not fully support the same console features that PowerShell or WSL provide.  

Because of this, some interactive Docker commands may not work as expected unless a tool such as winpty is used to fix the issue.
 
As a result, commands such as:  

```bash
docker exec -it <container-name> bash  
```

may produce the error message:  

```bash
"the input device is not a TTY"
```

**winpty** is a lightweight Windows utility that emulates a proper TTY environment so that interactive commands function correctly.  

Creating an alias ensures Docker commands automatically use winpty when launched from Git Bash, removing the need to type it manually each time:  

```bash
alias docker="winpty docker"
```

PowerShell and WSL do not require this workaround because both already provide native TTY support.

The command to update and upgrade packages within a running container is:  

```bash
sudo apt-get update && apt-get upgrade -y  
```

If the sudo command is not recognised, it can be installed with:  

```bash
apt-get install sudo  
```

Some lightweight base images, such as nginx, do not include nano or sudo by default. To edit files within the container, the nano text editor may need to be installed.

```bash
apt-get install nano  
``` 

```bash
sudo nano index.html
```

In certain cases, file edits can still be performed using pre-installed tools by  using stream editors like sed without installing nano.  

The nano installation step simply ensures a text editor is available if preferred.

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

Using a Dockerfile guarantees the custom homepage and image are always included when the image is rebuilt or shared.

![Nginx Modified Homepage with Dog Image](../images/nginx-homepage-edit-3.png)

## Further Examples of Container on Different Ports

**Apache (httpd):**

`docker run --name some-apache -d -p 8081:80 httpd`

![Apache HTTPD on Port 8081:80](../images/apache_httpd.png)

**Python Simple HTTP Server**

`docker run --name some-python -d -p 8082:8000 python:3.12-slim python -m http.server 8000`

![Python HTTP on Port 8082:80](../images/python-http.png)

**Nginx Dreamteam Container**

Attempting to run another container on the same port as the existing nginx container results in an error because port 80 is already in use by the first container. The Docker daemon prevents multiple containers from binding to the same host port.

Example error message:

```bash
Error response from daemon: driver failed programming external connectivity on endpoint nginx-257 (container_id): Bind for 0.0.0.0:80 failed: port is already allocated
```

The conflicting container must be removed or stopped before reusing the same port. To avoid this conflict, a different host port can be mapped to the container’s internal port 80.

```bash
docker run --name nginx-dreamteam -d -p 90:80 daraymonsta/nginx-257:dreamteam
```

This runs the nginx container using port 90 on the host machine while still connecting to port 80 inside the container. The webpage is then accessible at http://localhost:90 in a web browser, confirming the container is running successfully on a different port.

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

```bash
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

### Creating an Image from a Running Container

If a container is already running locally and includes changes made manually (for example, an edited index.html file or added assets), a new image can be created directly from that container without rebuilding from a Dockerfile.  

This is achieved using the commit command: 

```bash
docker commit <container-name> <new-image-name>  
```

The command takes a snapshot of the container’s current state and saves it as a new image, preserving all modifications.  

Once created, the image appears in the local list of images and can be tagged and pushed to Docker Hub in the same way as any other image.

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

![Successful Upload of Image to DockerHub] (../images/successful-upload-of-image-to-dockerhub.png)

3. Optionally, test by pulling the image back down to the local machine and running it:

```bash
docker pull exampleuser/host-custom-static-webpage:latest  
docker run -d -p 8080:80 exampleuser/host-custom-static-webpage:latest  
```
If the container runs and displays the expected application, the upload was successful.

## Docker Compose

**Docker Compose** is a tool for defining and running multi-container applications with a single YAML configuration file.


### Why Use Docker Compose?

Docker Compose simplifies the development, deployment, and management of containerised applications.

**Key Benefits:**

- **Simplified Control:**  
  Define and manage multiple containers in one YAML file, making orchestration and replication straightforward.  

- **Efficient Collaboration:**  
  Shareable Compose files ensure consistent environments and smoother collaboration between developers and operations teams.

- **Rapid Development:**  
  Compose caches configurations and reuses existing containers for unchanged services, allowing quick restarts and updates.  

- **Portability:**  
  Environment variables in Compose files allow customisation for different users or environments.

---

### Common Use Cases

**1. Development Environments**  
Compose lets developers spin up isolated environments with all dependencies (databases, queues, APIs, etc.) using a single command:

```bash
docker compose up
```

This replaces lengthy “getting started” guides with one configuration file and a few commands.

**2. Automated Testing Environments**  
In CI/CD pipelines, Compose can create and destroy isolated environments for end-to-end tests.  
Defining services in a Compose file ensures the same setup every time — ideal for repeatable, automated test runs.

## How to Use Docker Compose

### How to Install 

The easiest and recommended way to get Docker Compose is to install Docker Desktop.

Docker Desktop includes Docker Compose along with Docker Engine and Docker CLI which are Compose prerequisites.

### The Compose File

With Docker Compose, a YAML configuration file — known as the *Compose file* — is used to define an application's services.  

The Compose CLI uses this file to create, configure, and start all defined services together.

By default, the Compose file should be named **compose.yaml** (preferred) or **compose.yml**, and placed in the working directory.

### Starting and Stopping an Application

Once Docker Compose is installed and the configuration file is ready, the following commands are used to manage and control the application lifecycle.

```bash
docker compose up
```

Builds, (re)creates, starts, and attaches to all containers defined in the Compose file.  

If any required images are missing, Docker automatically pulls them from the registry or builds them locally.

When the command exits, all containers are stopped and logs are displayed directly in the terminal.  

This mode is useful for development or debugging since it provides real-time output from all running services.

To run containers in the background (detached mode), use the **--detach** flag.  

```bash
docker compose up --detach
```

This starts all services as background processes, freeing the terminal while keeping the containers active — ideal for long-running or production-like environments.

```bash
docker compose stop
```

The stop command stops all running containers without removing them.  
They can later be restarted using 

```bash
docker compose start
``` 

To completely remove containers, networks, and other resources created by *up*, use 

```bash
docker compose down
```

By default, this removes:  
- Containers for services defined in the Compose file.  
- Networks created for the application.  
- The default network, if one is used.
  
### Managing Individual Services

Docker Compose doesn’t have to manage everything in the file at once — individual services can be targeted.  

For example:  
- To start or stop only one service, specify its name after the command (e.g., docker compose up db or docker compose stop web).  
- Multiple services can be listed together to start or stop a specific subset.  

This allows more granular control during development or troubleshooting without affecting the rest of the stack.

---

### Running One-Time Commands

```bash
docker compose run web bash  
```

### Running One-Time Commands

docker compose run web bash  

The **run** command starts a temporary container for a service and runs a single command inside it.  

It’s mainly used for quick tasks such as testing, inspecting files, or performing setup steps.  

In this example, the command opens a bash shell inside the **web** service container.  
When the command finishes or the shell is closed, the container stops automatically.  

The **--detach** option runs the container in the background and prints its container ID instead of showing the output directly.


---

### Viewing Container Information

```bash
docker compose ps  
```
Lists all containers for the current Compose project, showing their status and exposed ports.  
This helps confirm which services are running and how they are mapped.  

```bash
docker compose logs  
```

Displays log output from running containers in real time.  

This shows information such as startup progress, connection attempts, and error messages.  

Logs can be viewed for all services or for a specific one by naming it, for example `docker compose logs web`

This helps monitor what each service is doing and makes it easier to identify issues as they happen.

```bash
docker compose images  
```

Lists all images used by the created containers in the project.  
  
Helps verify which images are being used and ensures they are up to date.

---

# Sparta Node Sample App – Containerisation and Deployment Documentation  

## Overview  

This documentation outlines the process of containerising the Sparta Node.js test application, running it in Docker, and extending it to use Docker Compose for managing multi-container environments. Each configuration file and command is explained clearly, describing what it does and why it is required.

---

## Stage 1: Containerising the Application 

The Sparta Node.js test app runs on Node v20 and serves three key pages:  

- Homepage (`localhost:3000`)  
- Blog posts page (`localhost:3000/posts`)  
- Fibonacci page (`localhost:3000/fibonacci/{index}`)  

The `/posts` route connects to a MongoDB database to display seeded data. Before seeding, only the page header is visible, indicating the connection is successful but no data exists yet.

---

### Dockerfile

#### Purpose  

The Dockerfile defines how to build a container image for the Node.js app. It specifies the base image, working directory, dependencies and startup commands.

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
- The `app` directory contains the main application files.

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
    image: chrleybolton/sparta-test-app:latest
    container_name: nodejs
    restart: unless-stopped
    env_file: ./.env
    depends_on:
      - mongodb
```

**nodejs:**  
- Defines a service named `nodejs`, which represents the Sparta Node.js application.  
- This service will build and run the app inside a container, using the Dockerfile from Stage 1.

**image: chrleybolton/sparta-test-app:latest**  
- Defines the image name and tag that will be created and optionally pushed to Docker Hub.  
- Ensures consistency between local builds and remote deployment environments.

**container_name: nodejs**  
- Assigns a fixed name to the running container.  
- Makes it easier to identify and connect to the container using Docker CLI commands (e.g., `docker exec -it nodejs bash`).

**restart: unless-stopped**  
- Automatically restarts the container if it stops unexpectedly (e.g., crash, reboot).  
- The container will only remain stopped if manually stopped by the user.
- Ensures reliable uptime and reduces the need for manual restarts after interruptions.

**env_file: ./.env**  
- Loads environment variables from the `.env` file in the project root directory.  
- These variables define connection credentials and hostnames for the MongoDB database.  
- This method centralises configuration and prevents hardcoding sensitive information inside the yml file.

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
    container_name: nginx  
    ports:  
      - 80:80  
    volumes:  
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro  
    depends_on:  
      - nodejs  
```

**nginx:**  
- Declares a service called `nginx`, representing the reverse proxy server.  
- This service enables users to access the application through standard web port 80 instead of port 3000.

**image: nginx:latest**  
- Pulls the latest version of the official Nginx image from Docker Hub.  
- Provides a lightweight, production-grade web server optimised for performance.

**container_name: nginx**  
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
    - `:ro` stands for read only. This prevents anything inside the container (including Nginx itself) from accidentally modifying your local config file.

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

---

### docker-compose.yml

#### Purpose

This configuration keeps MongoDB running in its own container, separate from the Node.js app, but still allows them to communicate securely.

Docker Compose automatically connects all containers to the same internal network, allowing Node.js to communicate with MongoDB using its service name instead of an IP address.

Because communication happens within this **private Docker network**, there’s no need to modify MongoDB’s bindIp setting — it already accepts connections from other containers on the same network.

The data is stored in a **volume**, meaning it’s saved on the local system even if the MongoDB container is stopped or recreated — ensuring the data remains intact.

```yml
  mongodb:  
    image: mongo:latest  
    container_name: mongodb  
    restart: unless-stopped  
    env_file: ./.env    
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

**container_name: mongodb**  
- Assigns a human-readable name to the MongoDB container.  
- Useful for debugging and for connecting via CLI commands.

**restart: unless-stopped**  
- Automatically restarts the container if it crashes or if the system reboots.  
- Keeps the database running reliably during development or testing.

**env_file: ./.env**  
- Loads database credentials and settings from the `.env` file.  
- Ensures consistency between the app and database configuration.

**volumes:**  
  - **mongo-data:/data/db**  
    - Links a local Docker volume named `mongo-data` to MongoDB’s data folder inside the container (`/data/db`).  
    - Keeps the database files safe and stored outside the container, so data is not lost if the container is deleted or rebuilt.  
    - Docker automatically keeps this data separate from the container’s temporary filesystem.

**volumes:**  
  - **mongo-data:**  
    - Declares the `mongo-data` volume used above.  
    - Docker creates and manages it automatically if it doesn’t already exist.  
    - This setup makes MongoDB’s data persistent across restarts and updates.

---

### .env File

#### Purpose

The `.env` file stores configuration variables required for the Node.js and MongoDB containers to connect correctly.  

It centralises configuration to avoid hardcoding credentials and environment-specific values in the source code.  
Docker Compose reads this file automatically whenever `env_file: ./.env` is defined in a service.

If MongoDB is running in authentication mode, credentials are required.

The values can be anything, but they must match the credentials created inside the MongoDB instance (for example, when seeding the DB or setting up user roles).

In a local development environment, simple placeholders like root / example are common.

In production, these should be replaced with strong, secret credentials (often stored securely via AWS Secrets Manager or Docker secrets).

In previous EC2-based deployments, environment variables were set directly within the instance (for example, using export commands or defined in PM2 or system service configurations), rather than being stored in a dedicated .env file. This approach provided similar functionality but lacked the automatic configuration management and portability offered by Docker Compose.


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

## Stage 4 – Database Seeding

Once the Node.js and MongoDB containers are running, the database must be seeded with initial data.  

---

### Purpose

Seeding populates the MongoDB database with sample data used by the application’s routes and tests. 

In this project, a seed script (`app/seeds/seed.js`) inserts predefined records into the `sparta` database.  
Seeding ensures that the `/posts` endpoint can return meaningful content and allows tests for the `/posts` route to pass successfully.

---

### Step-by-Step Seeding Instructions (Manual)

**1. Verify that all containers are running**

Ensure the Node.js and MongoDB containers are active and connected within the same Docker network:

```bash
   docker ps
```

Expected containers:
- `nginx`
- `nodejs`
- `mongodb`

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
  `docker ps | grep mongodb`
- Check the `.env` file for correct database credentials and host name.
- Confirm the connection string in `DB_HOST` matches the Compose service name (`mongodb`).
- Restart the containers:  
  `docker compose down` then `docker compose up -d`
- Retry seeding once services are stable.

---

### Automatic Seeding Methods

Automatic seeding populates the database with initial data as part of the deployment process.  

It removes the need for manual intervention, ensuring that essential data—such as default posts, users, or configuration values—is inserted whenever the application is first launched or redeployed.  

This approach improves consistency across environments, reduces human error, and speeds up setup for testing or development.  

In production environments, automatic seeding can be configured to run conditionally or with safeguards to prevent overwriting existing data.

**Method 1: Automatic Seeding via Node.js Container**

This method runs the seeding process automatically whenever the Node.js container starts. The seed script executes before the application begins, ensuring the database is always initialised with data.

### Updated Dockerfile

```yaml
CMD ["node", "app.js"]
```

is changed to 

```yaml
CMD ["bash", "-c", "node seeds/seed.js && node app.js"]  
```

**Explanation**

- `bash -c` runs multiple commands in sequence.  
- `node seeds/seed.js` populates MongoDB before the app launches.  
- `&&` ensures `node app.js` runs only after successful seeding.  

Note: This method cannot use the presaved Dockerfile image on Dockerhub in earlier steps so the compose.yml must be updated from

```yaml
nodejs:
image: chrleybolton/sparta-test-app:latest
```

to

```yaml
  nodejs:
    build: .
```

**Explanation**

- `build: .` uses the local Dockerfile so the seeding step runs.  
- Avoids using a prebuilt image that skips local CMD changes.  

---

**Method 2: Separate Seed Service (Using Existing Image)**

This method creates a dedicated container that runs the seed script automatically when the Docker Compose stack starts.  

It allows the existing prebuilt image from Docker Hub to be reused, avoiding the need to modify the Dockerfile or rebuild the image.

### Updated docker-compose.yml

  seed:
    image: chrleybolton/sparta-test-app:latest
    container_name: mongodb_seed
    env_file: ./.env
    command: bash -c "node seeds/seed.js"
    depends_on:
      - mongodb

**Explanation**

- `image` reuses the prebuilt application image already stored on Docker Hub, meeting the task requirement.  
- `command` overrides the image’s default start command, running the seed file instead of the main app.   
- `depends_on` ensures the seed container starts after MongoDB has initialised.  
- Once the script completes, the seed container exits successfully without restarting.

This method keeps MongoDB and the seeding logic separate, following good container design principles. The Mongo container runs only the database process, while the seed container runs a one-off data initialisation task.

*Note: the node.js service can be changed back to using the originally pushed image.*

---

### Why the Common Online Method Does Not Work

Many online examples suggest mounting a local `seeds` directory into MongoDB using `./seeds:/docker-entrypoint-initdb.d`

This approach relies on MongoDB’s built-in initialisation feature, which automatically executes any `.js` or `.sh` files in `/docker-entrypoint-initdb.d` when the database container is created for the first time.

However, it does not work in this case for two key reasons:

1. The `seed.js` file is written in Node.js using Mongoose and Faker.  
   The MongoDB container can only execute native Mongo shell scripts (using `db.posts.insert()` syntax). It cannot interpret Node.js files or use external libraries.

2. These scripts only run the first time the MongoDB volume is created.  
   If the database volume already exists, MongoDB detects existing data and skips the initialisation scripts entirely. This gives the false impression that the seed ran automatically when in fact the data persisted from a previous run.

---

### Importance of Using `docker compose down -v`

The `-v` flag removes any named volumes created by the Compose stack, including the MongoDB data volume.  

Without removing the volume, the old seeded data remains inside Docker, so the application appears to have seeded successfully even if the seed script did not run.

Running:

```bash
docker compose down -v
```

forces Docker to delete the existing volume, ensuring that MongoDB starts with a clean, empty database.  

This guarantees that any automatic seeding process actually executes rather than relying on leftover data.

---

*Other approaches such as using shell entrypoint scripts, Compose init jobs, or automated database migrations using tools like Prisma Migrate or Migrate-Mongoose can also perform automatic seeding. These were reviewed but not implemented within this project scope.*

---

## Launching The App on an EC2 Instance

Compared to setting up the application solely on EC2 with user data, which requires two separate EC2 instances for the app and database, Docker Compose manages container isolation and restart logic within a single machine. 

Each service (Node.js, MongoDB, Nginx) runs in its own container, which are isolated like lightweight virtual machines but communicate internally through Docker’s private network.  

Each service has a restart policy set to `unless-stopped`, ensuring that if one crashes, Docker automatically restarts it.  

Volumes maintain MongoDB data persistence, even if containers are stopped or rebuilt.  

This setup provides resilience benefits similar to a multi-EC2 deployment, managed locally by Docker.

**1 - Set up an EC2 instance**

AMI: Ubuntu 22.04 LTS
Instance type: t3.micro (fine for demo)
Key pair: create or reuse an existing .pem
Security Group: SSH (22) from Personal IP & HTTP (80) from anywhere

**2 - SSH into EC2 instance. Once in:**

```bash
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
```

**3 - Set up Docker's apt repository.**

Add Docker's official GPG key (key pair to allow access to the repo):

```bash
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add the repository to Apt sources:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
```

**4 - Install the Docker packages.**

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
```

The Docker service starts automatically after installation. To verify that Docker is running, use:

```bash
 sudo systemctl status docker
```

Verify that the installation is successful by running the hello-world image:

```bash
 sudo docker run hello-world
```

or viewing the versions installed:

```bash
Docker version 28.5.1, build e180ab8
Docker Compose version v2.40.2
```

**5 - Generate a Key Pair**

Generate a new SSH key pair on the EC2 instance: 

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Add the public key (`~/.ssh/id_ed25519.pub`) to the GitHub account under *Settings → SSH and GPG keys*.

Test the connection:

```bash
`ssh -T git@github.com`
```

**6 - Clone the app repository**

Clone the project repository using SSH

git clone <repo_url>
cd <name_of_repo>

**7 - Set up Docker Files**

If starting from a new repository, create the following files:

- `Dockerfile`
- `docker-compose.yaml`
- `nginx.conf`
- `.env`

If these files already exist, continue to the next step.

**8 - Start the Containers**

Start the containers:

```bash
sudo docker compose up -d
docker ps
```

`sudo` is required because the default Ubuntu user does not have Docker group permissions.

The Docker containers should now be running, and the application will be accessible via the **public IP address** of the EC2 instance.  

The `/posts` endpoint should be available once the stack is up.