Purpose: clarify why the Minikube IP is used in the NGINX reverse proxy while the EC2 public IP is used in the browser.

Summary:
- The application runs inside Minikube, which creates a private network (typically 192.168.49.0/24) isolated from the public internet.
- NGINX runs on the EC2 host and is publicly reachable on port 80 via the EC2 public IP.
- The reverse proxy must target the Minikube-internal NodePort service, which is only reachable at the Minikube IP and NodePort.
- External clients must connect to the EC2 public IP; the Minikube IP is not routable from the internet.

Traffic flow:
Browser → EC2 Public IP:80 → NGINX (host) → Minikube IP:30001 (NodePort) → Service → Pod (containerPort)

Key points:
- Minikube IP is an internal address presented by the Minikube network; it exposes NodePort services to the host, not to the internet.
- EC2 public IP is the only address visible externally; NGINX listens on this and forwards internally to the Minikube IP:NodePort.
- The reverse proxy target must not include a trailing slash to avoid path rewrite issues.

NGINX reverse proxy (essential lines only):
server {
    listen 80;
    listen [::]:80;

    location / {
        proxy_pass http://<MINIKUBE_IP>:30001;
        # no trailing slash after the port
        # example: proxy_pass http://192.168.49.2:30001;
    }
}

Security group essentials (inbound):
- 22/tcp from trusted admin IPs (SSH)
- 80/tcp from 0.0.0.0/0 (HTTP)
- No public exposure of NodePort or container ports required

Sanity checks (host shell):
- curl http://<MINIKUBE_IP>:30001       # validates NodePort from host to Minikube
- curl http://127.0.0.1                  # validates NGINX reverse proxy on host
- Browser → http://<EC2_PUBLIC_IP>       # validates end-to-end public access

Typical failure causes and fixes:
- 502 Bad Gateway: reverse proxy points to wrong target or includes a trailing slash; set proxy_pass to http://<MINIKUBE_IP>:30001 (no slash), reload NGINX.
- Connection refused on 127.0.0.1:30001: expected; NodePort binds inside Minikube, not on host loopback.
- NodePort unreachable: Minikube not running; start Minikube and verify pods/services are ready.

---

run the config

transfer over config 2.yml

A Kubernetes load balancer service is a component that distributes network traffic across multiple instances of an application running in a K8S cluster. It acts as a traffic manager, ensuring that incoming requests are evenly distributed among the available instances to optimize performance and prevent overload on any single instance, providing high availability and scalability.


change sg rules:
User → EC2 (port 80) → Nginx → Minikube → NodePort → App
Traffic enters on port 80 → already allowed → ✅

No need to open 30001 or 3000 to the world

App 2
scss
Copy code
User → EC2 (port 9000) → Nginx → Minikube Tunnel → App
Traffic enters EC2 on port 9000

EC2 security groups block ports by default

So we must open port 9000 in the inbound rules → ✅

clear the nginx.config with unneeded stuff and edit to so its like

sudo nano /etc/nginx/sites-available/default

server {
        listen 80;
        server_name _;

        location / {
                proxy_pass http://192.168.49.2:30001;
        }
}

server {
        listen 9000;
        server_name _;

        location / {
                proxy_pass http://10.98.208.55:9000;
        }
}

run minikube tunnel

tunnel creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP. minikube tunnel runs as a process, creating a network route on the host to the service CIDR of the cluster using the cluster's IP address as a gateway. The tunnel command exposes the external IP directly to any program running on the host operating system.

- expand o Specifics on how and why use minikube tunnel

A LoadBalancer is not the application — it’s just the way traffic reaches your application.

NodePort
- Opens a high port (e.g., 30002) on the node’s IP
- Useful for learning, not recommended for production
- Accessed as: http://<node-ip>:30002

LoadBalancer
- Allocates a stable external IP
- Routes via Service → Pods evenly
- Works with cloud providers (AWS ELB, Azure LB)
- Accessed as: http://<loadbalancer-ip>:9000

in a new session:

kubectl get svc nodejs-svc-2
You should see:

scss
Copy code
NAME             TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)           AGE
nodejs-svc-2     LoadBalancer   10.x.x.x       10.x.x.x        9000:30002/TCP    ...

instead of pending????


-- 

task 3

A Kubernetes Pod is a group of one or more Containers, tied together for the purposes of administration and networking. The Pod in this tutorial has only one Container. A Kubernetes Deployment checks on the health of your Pod and restarts the Pod's Container if it terminates. Deployments are the recommended way to manage the creation and scaling of Pods.

Use the kubectl create command to create a Deployment that manages a Pod. The Pod runs a Container based on the provided Docker image.

kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.53 -- /agnhost netexec --http-port=8080

kubectl get deployments
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
hello-node            1/1     1            1           10s

kubectl get pods
The output is similar to:

NAME                          READY     STATUS    RESTARTS   AGE
hello-node-5f76cf6ccf-br9b5   1/1       Running   0

By default, the Pod is only accessible by its internal IP address within the Kubernetes cluster. To make the hello-node Container accessible from outside the Kubernetes virtual network, you have to expose the Pod as a Kubernetes Service.

kubectl expose deployment hello-node --type=LoadBalancer --port=8080

The --type=LoadBalancer flag indicates that you want to expose your Service outside of the cluster.

The application code inside the test image only listens on TCP port 8080. If you used kubectl expose to expose a different port, clients could not connect to that other port.

kubectl get svc hello-node

NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
hello-node   LoadBalancer   10.98.136.202   10.98.136.202   8080:30201/TCP   6m3

HELLO_NODE_EXTERNAL_IP = 10.98.136.202

nginx.config

  GNU nano 6.2           /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;

    location /hello/ {
        proxy_pass http://10.98.208.55:8080/;
    }

    location / {
        proxy_pass http://192.168.49.2:30001;
    }
}

server {
    listen 9000;
    server_name _;

    location / {
        proxy_pass http://10.98.208.55:9000;
    }
}

-- very confused with this all explain what hello world is and what this is showing and why we use hello world ip for the nginx.config...

COMPLETE

Deploy three apps on minikube that will all run at the same time and be exposed to the outside world at different endpoints

· First app deployment:
o Should use a NodePort service at NodePort 30001
o Use image daraymonsta/nginx-257:dreamteam with container port 80 (or use your own image)
§ App container should have 5 replicas
o Use Nginx web server installed on the same cloud instance and configure reverse proxy to expose the app:
§ App should be accessed from the outside on <instance's public IP address> (default HTTP port)

· Second app deployment:

o Use a LoadBalancer service at port 9000, NodePort of LoadBalancer service 30002
o Use minikube tunnel to emulate a load balancer on the same cloud instance
o Use image daraymonsta/tech201-nginx-auto:v1 with container port 80 (or use your own image)
§ App container should have 2 replicas
o Use Nginx web server installed on the same cloud instance and configure reverse proxy to expose the app:
§ App should be accessed from the outside on <instance's public IP address>:9000

· Third app deployment:

o Deploy hello-minikube as the third app. § Use official documentation to help: https://kubernetes.io/docs/tutorials/hello-minikube/
o Use a LoadBalancer service at port 8080, NodePort of LoadBalancer service does not need to be specified
o Use minikube tunnel to emulate the load balancer on the same cloud instance (use the same tunnel service you already used for the second app's deployment)
o Use Nginx web server installed on the same cloud instance and configure reverse proxy to expose the app:
§ App should be accessed from the outside on <instance's public IP address>/hello

o How you cleanup and remove each deployment

- same as before kubectl get deployments, pods etc and delete all

o How to get Kubernetes working again after restarting the cloud instance

- minikube start
sudo -E minikube tunnel








---

· Deploy containerised 2-tier deployment (app and database) on a single VM using Minikube
· Database should use a PV of 100 MB (100mi)
· Use HPA to scale the app, min 2, max 10 replicas - load test to check it works 
· Use NodePort service and Nginx reverse proxy to expose the app service to port 80 of the instance's public IP ✅
· Make sure that `minikube start` happens automatically on re-start of the instance:

```bash
sudo nano /etc/systemd/system/minikube.service
```

Put this inside:

```bash
[Unit]
After=network.target

[Service]
ExecStart=/usr/local/bin/minikube start

[Install]
WantedBy=multi-user.target
```

Then run:

```bash
sudo systemctl daemon-reload
sudo systemctl enable minikube
sudo systemctl start minikube
```


ImagePullBackOff when image can't download as not enough space

```bash
df -h
```

If / or /var/lib/docker is > 90%, that’s the issue.

Remove unused images, containers, volumes, and cache:

```bash
docker system prune -a --volumes -f
```

This usually frees GBs.

Also remove old Minikube junk:

```bash
minikube delete
sudo rm -rf ~/.minikube
sudo rm -rf ~/.kube
```

Start fresh:

```bash
minikube start --driver=docker
```

Then confirm it’s alive:

``bash
kubectl get nodes
kubectl get pods -A
```
