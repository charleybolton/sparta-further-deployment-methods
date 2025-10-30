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



minikube start --driver=docker --cpus=2 --memory=1500 --addons=metrics-server --force
