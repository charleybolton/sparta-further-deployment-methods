- [Kubernetes Basics](#kubernetes-basics)
  - [Why Kubernetes is Needed](#why-kubernetes-is-needed)
  - [What Kubernetes Does](#what-kubernetes-does)
    - [What Kubernetes Is Not](#what-kubernetes-is-not)
  - [Benefits of Kubernetes](#benefits-of-kubernetes)
  - [Success Story: Booking.com](#success-story-bookingcom)
    - [Challenge](#challenge)
    - [Solution](#solution)
    - [Impact](#impact)
  - [Kubernetes Architecture](#kubernetes-architecture)
    - [Control Plane Components](#control-plane-components)
    - [Node Components](#node-components)
  - [Pros and Cons of Using a Managed Service vs Launching Your Own](#pros-and-cons-of-using-a-managed-service-vs-launching-your-own)
    - [Control Plane vs Data Plane](#control-plane-vs-data-plane)
  - [Kubernetes Objects](#kubernetes-objects)
    - [Types of Kubernetes Objects](#types-of-kubernetes-objects)
      - [Ephemeral Pods](#ephemeral-pods)
    - [How to Mitigate Security Concerns with Containers](#how-to-mitigate-security-concerns-with-containers)
    - [Maintained Images](#maintained-images)
      - [Pros](#pros)
      - [Cons](#cons)
  - [Installing Kubernetes with Docker Desktop](#installing-kubernetes-with-docker-desktop)
  - [Kubernetes Resource Definitions: Services, Deployments, and Jobs](#kubernetes-resource-definitions-services-deployments-and-jobs)
    - [Deployment](#deployment)
    - [Service](#service)
    - [Job](#job)
  - [Creating a Kubernetes Deployment](#creating-a-kubernetes-deployment)
    - [Applying the Deployment - Nginx](#applying-the-deployment---nginx)
    - [Viewing Deployment Details](#viewing-deployment-details)
  - [Getting a NodePort Service Running](#getting-a-nodeport-service-running)
    - [Creating the Service](#creating-the-service)
    - [Viewing Service Details](#viewing-service-details)
    - [Accessing the Application](#accessing-the-application)
    - [Why NodePort Access May Not Work on Some Systems](#why-nodeport-access-may-not-work-on-some-systems)
  - [Deleting a Pod](#deleting-a-pod)
    - [Why Kubernetes Pods Respawn After Deletion](#why-kubernetes-pods-respawn-after-deletion)
  - [Increasing Replicas with No Downtime](#increasing-replicas-with-no-downtime)
    - [Method 1 - Edit the Deployment File in Real-time](#method-1---edit-the-deployment-file-in-real-time)
    - [Method 2 - Apply a Modified Deployment File](#method-2---apply-a-modified-deployment-file)
    - [Method 3 - Use the Scale Command](#method-3---use-the-scale-command)
- [Node.js 20 Application – Kubernetes Deployment Documentation](#nodejs-20-application--kubernetes-deployment-documentation)
  - [Overview](#overview)
  - [Deployment Workflow](#deployment-workflow)
  - [File Purposes](#file-purposes)
    - [1. mongo-deploy.yml](#1-mongo-deployyml)
    - [2. mongo-service.yml](#2-mongo-serviceyml)
    - [3. node-deploy.yml](#3-node-deployyml)
    - [4. node-service.yml](#4-node-serviceyml)
    - [5. seed-job.yml](#5-seed-jobyml)
  - [Environment Variable Configuration](#environment-variable-configuration)
  - [Seed Job Breakdown](#seed-job-breakdown)

# Kubernetes Basics

## Why Kubernetes is Needed

Containers make it easy to package and run applications consistently across environments. In production, they must be monitored, updated, and replaced automatically to prevent downtime. Managing this manually can become complex and unreliable.  

Kubernetes is an **open-source container orchestration platform** that automates these operational tasks. It provides a framework for running distributed systems reliably, handling scaling, failover, and deployment strategies such as *canary releases* (where a new version is rolled out to a small subset of users before full deployment).

## What Kubernetes Does

**Kubernetes provides:**

- **Service Discovery and Load Balancing**  
  Exposes containers through DNS names or IP addresses and distributes traffic evenly to maintain performance and stability.

- **Storage Orchestration**  
  Mounts storage systems such as local disks, network storage, or cloud providers, allowing data to persist even when containers restart.

- **Automated Rollouts and Rollbacks**  
  Updates applications gradually by replacing old containers with new ones and rolls back automatically if issues occur.

- **Automatic Bin Packing**  
  Schedules containers efficiently across nodes based on CPU and memory requirements to maximise resource use.

- **Self-Healing**  
  Monitors container health and automatically restarts, replaces, or removes failed or unresponsive containers until they are ready to serve traffic.

- **Secret and Configuration Management**  
  Manages sensitive data such as passwords, tokens, and SSH keys securely, allowing updates without rebuilding container images.

- **Batch Execution**  
  Runs batch and CI workloads, automatically rescheduling containers if they fail to ensure jobs complete reliably.

- **Horizontal Scaling**  
  Scales applications up or down manually, via a dashboard, or automatically based on CPU or memory metrics.

- **IPv4/IPv6 Dual-Stack Support**  
  Assigns both IPv4 and IPv6 addresses to Pods and Services for flexible networking.

- **Designed for Extensibility**  
  Supports plug-ins and extensions to add functionality without modifying Kubernetes’ core codebase.

---

### What Kubernetes Is Not

Kubernetes is **not** a traditional all-in-one Platform as a Service (PaaS).  

It operates at the container level rather than the hardware level, offering deployment, scaling, and load balancing while remaining modular. Logging, monitoring, and alerting tools can be integrated as needed.  

Kubernetes provides the building blocks for developer platforms while maintaining flexibility and user choice.

---

## Benefits of Kubernetes

Kubernetes offers clear technical and operational advantages for managing containerised applications efficiently across any environment.

**Container orchestration savings**  
Automates container placement and resource management, reducing manual maintenance and downtime. Efficient scheduling means fewer servers, lower management costs, and less administrative overhead. Once clusters are configured, applications run reliably with minimal intervention.

**Increased DevOps efficiency for microservices**  
Simplifies development and deployment in microservices architectures. Containers make building, testing, and releasing faster than with virtual machines. Smaller teams can focus on individual services, improving collaboration and release speed. Namespaces provide structure and access control within clusters.

**Multicloud workload deployment**  
Supports consistent deployment across public, private, and hybrid clouds. Workloads can move easily between providers like AWS, Azure, and Google Cloud without performance loss. This flexibility reduces vendor dependency and simplifies migration between infrastructures.

**Portability and reduced vendor lock-in**  
Containers run lightweight, isolated workloads that share host resources, making them faster and more portable than virtual machines. Kubernetes works across almost any infrastructure or container runtime, allowing applications to scale and evolve without being tied to a single provider.

**Automated deployment and scalability**  
Deploys containers automatically and scales resources up or down based on demand. Autoscaling handles traffic spikes and scales back to save resources. Kubernetes can also roll back changes if updates fail, keeping applications stable.

**Application stability and availability**  
Maintains high availability through workload balancing, self-healing, and rolling updates. If a node or container fails, workloads are rescheduled automatically to maintain uptime and responsiveness during updates or failures.

**Open-source ecosystem**  
As an open-source project, Kubernetes benefits from a large global community that drives innovation and builds compatible tools. Its open ecosystem ensures continued improvement, strong cloud support, and long-term flexibility. Kubernetes integrates seamlessly with tools like Docker for complete container management.

---

## Success Story: Booking.com

### Challenge

In 2016, Booking.com migrated to an OpenShift platform to give product developers faster access to infrastructure. The approach initially worked well, but because Kubernetes was hidden behind OpenShift’s interface, developers lacked visibility into how the system worked. When issues occurred, the infrastructure team became a **knowledge bottleneck**, as developers depended on them for troubleshooting and support. Scaling this model proved unsustainable as the platform grew.

### Solution

After a year of operating OpenShift, the platform team decided to build a **vanilla Kubernetes platform** tailored to Booking.com’s needs. This shift required developers to learn Kubernetes fundamentals rather than relying on a fully abstracted system.

To support this transition, the team provided internal training resources, documentation, blog posts, and video tutorials.

Eduard Iacoboaia, Senior System Administrator, explained that while OpenShift helped the team enter the container landscape, building their own Kubernetes platform gave them a deeper understanding of how the components interact and more flexibility to customise for their scale.

### Impact

The results were significant.  

- Creating a new service, which previously took days or weeks depending on developer expertise, now takes **around 10 minutes**.  
- In the first **eight months**, developers built **500 new services** and began deploying hundreds of releases per day.  
- Internal adoption grew rapidly despite the learning curve, with developers forming an active support community to help one another.  

> “As our users learn Kubernetes and become more sophisticated, they put pressure on us to provide a better, more native experience,” said Tyler. “It’s a super healthy dynamic.”

The new platform provided flexibility for different skill levels. Advanced users could work directly with the Kubernetes API, while others used preconfigured base images for common stacks like **Perl** and **Java**.

It also made use of Kubernetes’s open ecosystem, integrating other cloud-native tools to extend its capabilities:  
- **Envoy** managed communication between services, ensuring reliable and efficient traffic.  
- **Helm** simplified how applications were packaged, deployed, and updated.  
- **Prometheus** tracked performance and helped identify issues quickly.  

These integrations reflected the team’s growing Kubernetes expertise and demonstrated one of the platform’s core strengths—its ability to work seamlessly with other open-source technologies to create custom, scalable solutions.

The team also developed and shared **Shipper**, their own tool for managing application rollouts and maintaining consistent deployments across multiple environments.

By moving from a closed, abstracted system to a transparent Kubernetes environment, Booking.com not only improved developer autonomy and speed but also cultivated an internal culture of shared learning and continuous improvement.

## Kubernetes Architecture 

![Diagram Showing the Kubernetes Architecture](../images/kubernetes-architecture.png)

Kubernetes follows a **client–server architecture**, made up of a **control plane (master node)** and one or more **worker nodes**.  

The control plane manages the cluster, while worker nodes run the actual applications in containers.

A typical setup includes:
- A **master node** running core management components like the API Server, Scheduler, Controller Manager, and `etcd` database.
- **Worker nodes** running services such as the Kubelet (to communicate with the master), Kube-Proxy (for networking), and a container runtime such as Docker.

---

### Control Plane Components

The control plane acts as the **brain** of the cluster, maintaining its desired state by deciding what should run, where, and when.

**1. API Server**  
The central communication hub for the cluster. It processes requests from `kubectl` (the command-line tool used to interact with a Kubernetes cluster) or other tools, validates them, and forwards them to other components. All interactions with the cluster go through the API Server.

**2. Scheduler**  
Assigns new Pods to the most suitable worker nodes based on available resources and workload distribution.

**3. Controller Manager**  
Runs various controllers that manage cluster state, such as keeping the right number of Pods running and monitoring node health.

**4. etcd**  
A distributed key-value store that holds the cluster’s configuration and current state which is essentially, the cluster’s memory.

---

### Node Components

Worker nodes are where the actual workloads run. Each node can host multiple **Pods**, which contain one or more containers.

**1. Container Runtime**  
The software responsible for running containers inside Pods. Common examples include **Docker** or **containerd**.

**2. Kubelet**  
An agent on each node that ensures containers are running as expected. It communicates with the control plane to start, stop, and report on Pods.

**3. Kube-Proxy**  
Handles networking inside the cluster, routing traffic from Services to the correct Pods and balancing requests between them.

A **Kubernetes cluste**r is the collection of all the machines (physical or virtual) that run Kubernetes together.

---

## Pros and Cons of Using a Managed Service vs Launching Your Own

| Category | **Managed Service (for example AWS EKS, GKE, AKS)** | **Self-Hosted or Launch Your Own Cluster** |
|-----------|------------------------------------------------------|--------------------------------------------|
| **Management and Maintenance** | Managed entirely by the provider, who handles updates, scaling, backups, and patching. | Fully managed in-house, meaning your team is responsible for installation, monitoring, and maintenance. |
| **Control and Customisation** | Offers limited control over configurations and infrastructure. | Provides full control and flexibility to tailor the environment to your exact requirements. |
| **Scalability** | Scales automatically based on demand and includes built-in high availability. | Scaling requires manual setup of new hardware or virtual machines and configuration changes. |
| **Cost Structure** | Uses a pay-as-you-go model that avoids large upfront costs but includes ongoing usage fees. | Involves higher initial hardware and setup costs, though long-term expenses can be lower if optimised. |
| **Technical Expertise** | Requires minimal in-house expertise, making it ideal for smaller teams and startups. | Needs skilled DevOps or infrastructure engineers to deploy, manage, and troubleshoot effectively. |
| **Security and Reliability** | Security, compliance, and uptime are managed by the provider’s specialist teams. | All responsibility for securing systems, backups, and recovery lies with your own organisation. |
| **Agility and Speed** | Enables quick setup and faster time to market, allowing teams to focus on product development. | Takes longer to deploy and maintain, with more time spent managing infrastructure instead of building features. |
| **Portability** | May introduce some dependency on a specific cloud provider’s ecosystem. | Makes it easier to move workloads between environments or providers if required. |
| **Best Fit** | Suited to startups and growing teams that value speed, reliability, and reduced operational work. | Suited to enterprises or organisations that require strict compliance, full control, or advanced customisation. |

---

### Control Plane vs Data Plane

In Kubernetes, as in many cloud systems, the control plane and data plane work together but serve very different purposes.

The **control plane** is the decision-making layer. It provides the administrative interface that manages and maintains the overall state of the cluster. The control plane handles tasks such as scheduling workloads, monitoring health, scaling applications, and updating configurations. It exposes APIs that let users or tools create, read, update, and delete cluster resources. In simple terms, it decides what should happen and coordinates the actions needed to make it so.

The **data plane** is the execution layer. It performs the actual work requested by the control plane, such as running Pods, storing data, and routing network traffic. When a new workload is scheduled, the data plane is where it runs. This layer is generally simpler, with fewer moving parts, which makes it more stable and less prone to failure.

Together, these planes separate management from operation. The control plane plans and orchestrates, while the data plane carries out those instructions. This design improves performance, reliability, and scalability across the entire cluster.

## Kubernetes Objects

Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of the cluster. Specifically, they can describe:

- What containerized applications are running (and on which nodes)
- The resources available to those applications
- The policies around how those applications behave, such as restart policies, upgrades, and fault-tolerance

A Kubernetes object is a "record of intent", so following the creation of an object, the Kubernetes system will constantly work to ensure that the object exists. 

By creating an object, it's effectively telling the Kubernetes system what the cluster's cluster's workload should look like; the cluster's desired state.

### Types of Kubernetes Objects  

- **Deployment**  
  A Deployment is a Kubernetes object that represents the desired state of an application running on the cluster.  
  It defines how many replicas of the application should exist and manages the creation and updates of ReplicaSets to match that specification.  
  As an object, it acts as a record of intent—Kubernetes continuously monitors the cluster and takes action to ensure the running state of the application aligns with what the Deployment declares.

- **Pod**  
  A Pod is a core Kubernetes object and the smallest deployable unit in the system.  
  It defines the desired state of one or more tightly coupled containers that share storage, networking, and configuration.  
  As an object, the Pod tells Kubernetes how a particular group of containers should run, and the system ensures those containers exist and remain in the specified state.

- **ReplicaSet**  
  A ReplicaSet is a Kubernetes object that defines and maintains a desired number of identical Pod replicas.  
  It includes a selector to match the Pods it manages and a Pod template that describes how new Pods should be created.  
  Acting as a record of intent, the ReplicaSet ensures that the actual number of running Pods always matches the number defined in its specification—automatically creating or deleting Pods as needed.

#### Ephemeral Pods

Regular containers are part of a Pod’s intended design — they are defined in the Pod specification, managed by controllers like Deployments or ReplicaSets, and automatically restarted or replaced if they fail.  
They have assigned resources, health checks, and networking configurations that allow them to serve application workloads reliably.  

Ephemeral containers, by contrast, are **short-lived**, **manually added**, and **used for inspection only**.  

They are **temporary** containers added to an existing Pod, usually for **debugging or troubleshooting**.  

They differ from regular containers in that they are **not defined in the Pod spec**, **lack restart or resource guarantees**, and **cannot expose ports or probes**.  

They are created through a special API (`ephemeralcontainers` handler) rather than being part of a Deployment or ReplicaSet configuration.  

For example, if a production Pod is running a minimal (“distroless”) image without debugging tools, a developer can attach an ephemeral container with shell utilities to inspect logs or running processes — something not possible with the original application container.

### How to Mitigate Security Concerns with Containers  

1. **Apply least-privilege access and RBAC controls**  
   Use the built-in Kubernetes Role-Based Access Control (RBAC) system to restrict what users, service accounts, and workloads can do, following the principle of least privilege.  

2. **Use Pod Security Standards and admission controls**  
   Enforce Pod-level policies using the Kubernetes Pod Security Admission (PSA) system or admission controllers to prevent risky configurations (for example, running as root or using host network access).  

3. **Scan and maintain container images and apply updates**  
   Continuously scan base and built images for vulnerabilities (CVEs) and apply security patches promptly. Using minimal, well-maintained images helps reduce the attack surface.  

4. **Harden the host and runtime environment**  
   Keep the host operating system, container runtime, and other dependencies up to date. Configure them securely with minimal privileges and strong isolation.  

5. **Secure secrets and sensitive data**  
   Use the Kubernetes Secrets Store CSI Driver or external secret managers. Enable encryption at rest for Secrets in etcd and limit access through RBAC.  

6. **Implement network and workload isolation**  
   Apply Network Policies to control communication between Pods. Use Namespaces and labels to separate workloads and restrict access between environments.  

7. **Monitor, audit, and log cluster activity**  
   Enable audit logging for the API server, monitor for unexpected behaviour, and use vulnerability scanning and alerting tools to detect and respond to security issues.  

---

### Maintained Images  

Maintained images are container base images that are regularly updated, patched, and managed by a dedicated team or trusted provider.  

They are considered **trusted foundations** for building application containers because they come with verified dependencies, security hardening, and compatibility testing.  

Using maintained images helps ensure that all containers in a deployment start from a consistent and secure baseline, reducing the risk of vulnerabilities introduced by outdated or unverified sources.  

This approach also simplifies maintenance, as updates and patches can be applied centrally to the base image rather than individually across every application container.

#### Pros  
- **Improved security**: Regularly patched images reduce vulnerabilities and ensure the base environment remains secure.  
- **Consistency and standardisation**: Shared, approved images simplify compliance, auditing, and troubleshooting.  
- **Operational efficiency**: Developers can focus on building applications instead of maintaining base images themselves.  

#### Cons  
- **Reduced flexibility**: Some applications may need custom dependencies or configurations not included in the maintained image.  
- **Maintenance responsibility**: Managed images still require ownership and testing to ensure compatibility after updates.  
- **Potential slow updates**: Strictly controlled or centrally maintained images may delay the adoption of new software versions or tools.  

---

## Installing Kubernetes with Docker Desktop  

1. Open a **Git Bash** window (on Windows) or **Terminal** (on Mac) and check if Kubernetes is running:  

```bash
kubectl get service  
```

Expected output:  

NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S) AGE  
kubernetes ClusterIP 10.96.0.1 <none> 443/TCP 3m56s

2. If Kubernetes is not running, an error message will appear indicating that the connection cannot be established. Keep this terminal window open.  

3. In **Docker Desktop**, navigate to:  
   **Settings → Kubernetes → Enable Kubernetes**, then select **Install**.  

4. Return to the terminal window and verify that Kubernetes is now running:  

---

## Kubernetes Resource Definitions: Services, Deployments, and Jobs

### Deployment

A **Deployment** is a higher-level abstraction used to manage a set of identical pods. It defines the desired state of an application, including the number of replicas, container images, and update strategy. Kubernetes continuously monitors the cluster to ensure that the actual state matches the defined desired state.

Deployments are primarily used for long-running, stateless applications that require high availability, scalability, and easy updates. When updates are made to a Deployment, Kubernetes handles the rollout process gradually to avoid downtime, while also providing rollback capabilities in case of failure.

**Key responsibilities:**
- Maintaining the specified number of pod replicas.
- Automatically replacing failed or unresponsive pods.
- Rolling out and rolling back updates safely.
- Scaling applications up or down as required.

---

### Service

A **Service** defines a stable network endpoint for accessing one or more pods. Since pods are ephemeral and can change their IP addresses, Services provide a consistent interface that other components or external users can use to communicate with the application.

Services use label selectors to match pods and route traffic to them using a load-balancing mechanism. The type of Service determines how and where the application is exposed.

**Key responsibilities:**
- Providing stable DNS names and IP addresses for pod groups.
- Distributing network traffic across multiple pod instances.
- Managing internal and external accessibility of applications.

**Common Service types:**
- **ClusterIP:** Exposes the service only within the cluster (default type).
- **NodePort:** Exposes the service externally via a static port on each node.
- **LoadBalancer:** Provisions an external load balancer (cloud environments).

---

### Job

A **Job** is used to run a pod or set of pods until a specific task completes successfully. Unlike Deployments, which maintain continuous service availability, Jobs are designed for finite, one-off, or batch tasks that must reach completion before terminating.

Jobs can be configured to retry on failure and can run multiple pods in parallel to process workloads faster. When all pods finish successfully, the Job is considered complete.

**Key responsibilities:**
- Executing tasks that need to run to completion.
- Managing retries for failed executions.
- Supporting parallel or sequential processing for batch workloads.

Common use cases include database migrations, data processing scripts, report generation, or other time-bound processes that do not require continuous operation.

---

## Creating a Kubernetes Deployment

The following Deployment configuration defines an NGINX application running with three replicas. Each Pod uses the `daraymonsta/nginx-257:dreamteam` image, exposes port 80, and is labelled with `app: nginx`.  

```yaml
apiVersion: apps/v1  
# Specifies the API version to use for this Deployment resource  

kind: Deployment  
# Defines the Kubernetes object type being created  

metadata:  
  name: nginx-deployment  
  # Names the Deployment resource  
  labels:  
    app: nginx  
    # Adds a label to identify this Deployment and its Pods  

spec:  
  replicas: 3  
  # Specifies how many Pod replicas should run  
  selector:  
    matchLabels:  
      app: nginx  
      # Matches Pods with this label to associate them with the Deployment  
  template:  
    # Defines the template used to create Pods for this Deployment  
    metadata:  
      labels:  
        app: nginx  
        # Assigns the same label to Pods so they match the selector above  
    spec:  
      containers:  
      - name: nginx  
        # Names the container running inside each Pod  
        image: daraymonsta/nginx-257:dreamteam  
        # Specifies the container image to use from Docker Hub  
        ports:  
        - containerPort: 80  
          # Exposes port 80 inside the container for network traffic  
  
``` 

---

### Applying the Deployment - Nginx  

Create the Deployment:  

```bash
kubectl apply -f nginx-deployment.yaml  
```

Expected output:  

```bash
deployment.apps/nginx-deployment created  
```

---

### Viewing Deployment Details  

Check the Deployment:  

```bash
kubectl get deployments  
```

Example output:  

```bash
NAME               READY   UP-TO-DATE   AVAILABLE   AGE  
nginx-deployment   3/3     3            3           77s  
```

Check the ReplicaSet:  

```bash
kubectl get rs  
```

Example output:  

```bash
NAME                         DESIRED   CURRENT   READY   AGE  
nginx-deployment-bf744486c   3         3         3       111s  
```

Check the Pods:  

```bash
kubectl get pods  
```

Example output: 

```bash
NAME                               READY   STATUS    RESTARTS   AGE  
nginx-deployment-bf744486c-hm59v   1/1     Running   0          2m28s  
nginx-deployment-bf744486c-khj6l   1/1     Running   0          2m28s  
nginx-deployment-bf744486c-p7bzw   1/1     Running   0          2m28s  
```

To view details for all resources related to the Deployment in a single command:  

```bash
kubectl describe deployment nginx-deployment  
```

Alternatively, to list all resource types in the current namespace, including Deployments, ReplicaSets, Pods, and Services:  

```bash
kubectl get all  
```

---

## Getting a NodePort Service Running  

The following Service configuration exposes the NGINX Deployment to external traffic using a NodePort.

Each node in the cluster will listen on port **30001** and route traffic to port **80** on the NGINX Pods.  

```yaml
apiVersion: v1  
# Specifies the API version for the Service resource  

kind: Service  
# Defines the Kubernetes object type being created  

metadata:  
  name: nginx-svc  
  # Names the Service resource  

spec:  
  type: NodePort  
  # Exposes the Service externally by opening a specific port (the NodePort) on each node in the cluster. This allows traffic from outside the cluster (for example, from a web browser on the local machine) to be forwarded into the cluster and sent to the correct Service and Pod.  

  ports:  
  - port: 80  
    # The port on which the Service is exposed inside the cluster  
    targetPort: 80  
    # The port on the Pod that receives traffic  
    nodePort: 30001  
    # The external port on each node used to access the Service  

  selector:  
    app: nginx  
    # Links the Service to Pods with the label app=nginx  
```

| Field | Description | How to Determine Value | Example |
|--------|--------------|-------------------------|----------|
| **`port`** | The internal port exposed within the cluster that other Services or Pods use to communicate. | Match the internal communication port required by the application. Often identical to `targetPort`. | `80`, `8080`, `3000` |
| **`targetPort`** | The port on the Pod that receives traffic from the Service. | Match the port on which the application process listens inside the Pod. Can be confirmed from application configuration, process arguments, or container logs. | `80`, `8080`, `3000` |
| **`nodePort`** | The external port on each cluster node that allows access from outside the cluster. | Select any unused port within the range `30000–32767`. This value maps incoming external traffic to the internal `port`. | `30001` |


---

### Creating the Service  

Create the Service using the following command:  

```bash
kubectl apply -f nginx-service.yaml  
```

Expected output:  

```bash
service/nginx-svc created  
```

---

### Viewing Service Details  

List all Services running in the cluster:  

```bash
kubectl get services  
```

Example output:  

```bash
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE  
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP        171m  
nginx-svc    NodePort    10.98.92.166   <none>        80:30001/TCP   2m33s
```

---

### Accessing the Application  

Open a web browser and go to:  

`http://localhost:30001`

This address routes traffic through the NodePort Service to the NGINX Pods, displaying the modified NGINX welcome page.

![Nginx Dream Team Home Page](../images/dreamteam-homepage.png)

---

### Why NodePort Access May Not Work on Some Systems  

When Kubernetes runs through Docker Desktop on **Mac** or **Linux**, NodePort traffic is correctly forwarded from the local machine to the Kubernetes node.  

However, on **Windows**, Docker Desktop runs Kubernetes inside a lightweight virtual machine.  

In that configuration, NodePort ports (such as 30001) are open only **inside the VM**, not directly on the host operating system.  

As a result, traffic sent to `http://localhost:30001` does not reach the cluster.  

In such cases, the application can be accessed locally by using **port forwarding** instead:  

```bash
kubectl port-forward service/nginx-svc 8080:80  
```

This command creates a direct tunnel between the local port **8080** and the Service port **80**, allowing access through:  

```bash
http://localhost:8080  
```

In this command, **`service`** represents the Kubernetes **object type**, and **`nginx-svc`** is the **object name** of the Service resource being forwarded.  

This method bypasses the network isolation caused by Docker Desktop’s virtualisation on Windows systems.  

---

## Deleting a Pod

With the nginx-deployment Deployment and nginx-svc Service running, listing all available pods using `kubectl get pods`

will provide an output similar to

```bash
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-67c68f6d64-hstcj   1/1     Running   0          5m10s
nginx-deployment-67c68f6d64-ktsck   1/1     Running   0          5m10s
nginx-deployment-67c68f6d64-kv4pz   1/1     Running   0          5m10s
```

To delete a specific pod use the command

```bash
kubectl delete pod <pod name>
```

e.g.

```bash
kubectl delete pod nginx-deployment-67c68f6d64-kv4pz
```

If the `kubectl get pods` command is re-run immediately after the deletion, the output will look similar to

```bash
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-67c68f6d64-5sbdw   1/1     Running   0          4s
nginx-deployment-67c68f6d64-hstcj   1/1     Running   0          9m41s
nginx-deployment-67c68f6d64-ktsck   1/1     Running   0          9m41s
```

The reaction to a deletion is the spawning of a new pod immediately after.

To find out detailed information on a particular pod use:

```bash
kubectl describe pod <pod name>
```

This command displays the full specification and current state of the Pod, including container details, resource usage, environment variables, assigned node, and recent events.  

It is useful for diagnosing issues such as failed image pulls, scheduling delays, restarts, or crash loops.  

The **Events** section at the bottom of the output provides a chronological list of lifecycle actions, helping identify why a Pod was restarted or replaced.

### Why Kubernetes Pods Respawn After Deletion

Pods in Kubernetes are designed to be **ephemeral** — they are not meant to live forever.  
When a Pod is deleted, the Kubernetes control plane recognises that the actual cluster state no longer matches the **desired state** declared in its managing object (for example, a **Deployment**, **ReplicaSet**, or **StatefulSet**).  

Kubernetes uses a reconciliation loop that constantly checks the difference between:
- **Desired state** (what the manifest or object specification says should exist)
- **Current state** (what is actually running in the cluster)

If a Pod is manually deleted, the controller responsible for it detects that the desired number of replicas is no longer running. It then automatically creates a new Pod to bring the system back to the desired state.  

The proper way is to delete the deploy that creates the pod using:

```bash
kubectl delete deployment <deployment name>
```

This command is used to remove one or more deployments from a cluster, which stops the managed pods and deletes the associated ReplicaSets.

In this command:  
- `deployment` represents the **object type** - the kind of Kubernetes resource to delete.  
- `<deployment_name>` represents the **object name** - the specific instance of that resource currently running in the cluster.  

## Increasing Replicas with No Downtime

Scaling a Kubernetes Deployment allows the number of running Pod replicas to be increased or decreased in real time, without the need to delete or recreate the existing Deployment.  

This ensures that applications can dynamically adjust to workload demands or maintenance requirements while remaining available.  

There are several methods to achieve this, each suited to different operational contexts and automation levels.

### Method 1 - Edit the Deployment File in Real-time

The edit command allows direct editing of any API resource that can be retrieved via the command-line tools.  

It opens the editor defined by the `KUBE_EDITOR` or `EDITOR` environment variables, or defaults to **vi** on macOS/Linux and **Notepad** on Windows.

The Deployment file can be edited in real time using:

```bash
kubectl edit <resource_type> <resource_name>
```
```bash
kubectl edit deployment nginx-deployment
```

Unlike commands that use a filename, `kubectl edit` works directly with **live objects** stored in the cluster, allowing changes to the active resource rather than a local configuration file.

If using macOS, the file will open in **vi mode**, which starts in normal mode (cannot type).  
Press `i` to enter insert mode to make changes.

If using Windows, the file will open in **Notepad**, where edits can be made normally without additional commands.

- Locate the line: `replicas: 3`  
- Change to: `replicas: 4`  
- Save and exit  
  - vim: `:wq`  
  - Notepad: Save the file and close the window  

![CLI Output Using the `kubectl edit` Command](../images/increasing-replicas-1.png)

### Method 2 - Apply a Modified Deployment File

This method updates the Deployment based on a local YAML manifest, rather than editing the live object directly.  

By re-running the apply command, any new configuration will be applied to a resource by the specified file name.  

This resource will be created if it doesn't exist yet, as seen before.

```bash
kubectl apply -f <filename>
```
```bash
kubectl apply -f nginx-deploy.yml
```

![CLI Output Using the `kubectl apply` Command](../images/increasing-replicas-2.png)


### Method 3 - Use the Scale Command

The `scale` command changes the number of replicas for a running resource such as a Deployment, ReplicaSet, ReplicationController, or StatefulSet, without modifying the original YAML file.  

It can be used to increase or decrease the number of Pods directly from the command line.  

```bash
kubectl scale <resource_type>/<resource_name> --replicas=<number>
```
```bash
kubectl scale deployment/nginx-deployment --replicas=6  
```

This updates the live Deployment to run six replicas of the application immediately, without requiring a redeploy or edit.  

![CLI Output Using the `kubectl scale` Command](../images/increasing-replicas-3.png)


---


# Node.js 20 Application – Kubernetes Deployment Documentation  


## Overview  


![Diagram Showing the Kubernetes Architecture for NodeJs Sparta App Set Up](../images/kubernetes-architecture-sparta-app.png)


This documentation explains how to deploy a **Node.js 20** application in a Kubernetes cluster. It walks through creating Deployment and Service manifests for both the **Node.js** application and **MongoDB**, configuring environment variables, and using a **Job** to seed the database.  

The deployment process builds upon a basic NGINX example, extending it into a functional full-stack setup. A Kubernetes architecture diagram (recommended) can visually demonstrate how Deployments, ReplicaSets, Pods, and Services interact within the cluster.  

---

## Deployment Workflow  

The files should be applied in the following order to ensure all dependencies are created in sequence:  

1. **mongo-deploy.yml** – Creates the MongoDB Deployment.  
2. **mongo-service.yml** – Exposes MongoDB internally so other Pods can connect.  
3. **node-deploy.yml** – Deploys the Node.js application, connecting to MongoDB using an environment variable.  
4. **node-service.yml** – Exposes the Node.js app externally via NodePort for local access.  
5. **seed-job.yml** – Runs once to populate the MongoDB database with seed data.  

This order ensures that MongoDB is available before the Node.js application starts, and that both are running before the seed Job attempts to insert data.  

---

## File Purposes  

### 1. mongo-deploy.yml  
Defines a Deployment running a single MongoDB Pod.  
- Uses an **emptyDir** volume for temporary data storage.  
- Runs the MongoDB container on port **27017**.  

### 2. mongo-service.yml  
Exposes MongoDB as an internal **ClusterIP Service**.  
- Makes MongoDB reachable at `mongo-svc:27017` from within the cluster.  
- The `mongo-svc` hostname is used by the Node.js application to connect.  

### 3. node-deploy.yml  
Creates the Node.js Deployment with multiple replicas.  
- Typically runs **three replicas** for load balancing and redundancy.  
- Connects to MongoDB via an environment variable (`DB_HOST`).  
- Uses the Docker image built for the Node.js application (for example, `chrleybolton/sparta-test-app:latest`).  

### 4. node-service.yml  
Exposes the Node.js Pods externally using a **NodePort Service**.  
- Routes traffic from `http://localhost:<nodePort>` to port **3000** inside each Pod.  
- Enables external access for testing and development.  

### 5. seed-job.yml  
Runs a one-time **Kubernetes Job** to populate MongoDB with initial data.  
- Uses the same Node.js image as the application.  
- Executes a seeding script (`node seeds/seed.js`).  
- Connects to MongoDB using the `DB_HOST` environment variable.  

---

## Environment Variable Configuration  

The Node.js Deployment includes an environment variable for the MongoDB connection:

```yml
    env:
    - name: DB_HOST
      value: "mongodb://mongo-svc:27017/sparta"
```

**Explanation:**  
- `DB_HOST` is the name of the environment variable read by the application.  
- `mongo-svc` is the internal DNS name of the MongoDB Service.  
- `27017` is MongoDB’s default port.  
- `sparta` is the database name.  

This setup allows the Node.js application to dynamically connect to the MongoDB Pod using Kubernetes’ internal DNS resolution.  

---

## Seed Job Breakdown  

```yml
apiVersion: batch/v1  
# Specifies the Kubernetes API version used for the Job resource  

kind: Job  
# Defines the type of Kubernetes object; a Job runs tasks to completion rather than continuously like a Deployment  

metadata:  
  name: mongodb-seed  
  # Names the Job so it can be identified, monitored, or referenced later  

spec:  
  backoffLimit: 3  
  # Specific to Jobs: limits how many times Kubernetes retries the Job if it fails before being marked as failed  
  # Ensures a failed seed script doesn’t retry indefinitely  

  template:  
    # Required for Jobs: defines the Pod specification that the Job will create to run its task once and then exit  

    spec:  
      restartPolicy: Never  
      # Specific to Jobs: prevents the Pod from restarting automatically after completion or failure  
      # Ensures the Job runs only once and doesn’t continuously restart like a long-running Deployment Pod  

      containers:  
      - name: mongodb-seed  
        # Names the container inside the Job Pod  

        image: chrleybolton/sparta-test-app:latest  
        # Specifies the container image that includes the code or scripts needed to seed the database  

        command: ["bash", "-c", "node seeds/seed.js"]  
        # Overrides the container’s default command to execute the seed script using Node.js  

        env:  
        - name: DB_HOST  
          # Defines an environment variable that stores the MongoDB connection variable name  

          value: "mongodb://mongo-svc:27017/sparta"  
          # Sets the actual MongoDB connection URI using the internal service name, port, and database name  
```

---

