---

· Deploy containerised 2-tier deployment (app and database) on a single VM using Minikube
· Database should use a PV of 100 MB (100mi)
· Use HPA to scale the app, min 2, max 10 replicas - load test to check it works 
· Use NodePort service and Nginx reverse proxy to expose the app service to port 80 of the instance's public IP ✅
· Make sure that `minikube start` happens automatically on re-start of the instance:

- Follow same process as before with deploying application 1 including the reverse proxy 
- But now need to do mongo storage, config and seed, scalers
- Changes:

added this to mongodb config:

        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"

explain why we did this

added this to app config:

          requests:
            cpu: "100m"
            memory: "64Mi"
          limits:
            cpu: "200m"
            memory: "256Mi"

explain basically why we added this

apart from that p much everything was same as before except the memory size

The disk space issue caused the crash, yes.

But the memory constraints are still necessary on t3a.small.

Removing them will cause the HPA scale test to crash the node again.

MongoDB and Node both expand memory usage under load.
The HPA increases replicas, which multiplies memory usage.

Without limits → the kernel OOM killer will delete your pods.

So even after fixing disk, the resource limits are still required to keep the cluster stable during scaling.


TROUBLESHOOT:


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

clear minkube:

minikube delete --all --purge
minikube start --driver=docker --cpus=2 --memory=1800 --addons=metrics-server --force

if still getting:

nodejs-deployment-5fd986d84f-hm8ww   0/1     ImagePullBackOff   0             77s

Try pulling image seperately to see the issue:

docker pull chrleybolton/sparta-test-app:latest
> failed to register layer: write /usr/lib/x86_64-linux-gnu/security/pam_mkhomedir.so: no space left on device

The node can’t pull the image because the Docker filesystem is full. We fix that first before touching anything else.

> sudo docker system prune -a --volumes -f


This removes:

- old images
- unused containers
- build layers
- dangling volumes


Total reclaimed space: 0B
ubuntu@ip-172-31-23-153:~$ df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        7.6G  7.3G  320M  96% /
tmpfs            959M     0  959M   0% /dev/shm
tmpfs            384M  984K  383M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.8K  120K   4% /sys/firmware/efi/efivars
/dev/nvme0n1p15  105M  6.1M   99M   6% /boot/efi
tmpfs            192M  4.0K  192M   1% /run/user/1000

Step 1 — Go to AWS Console → EC2 → Instances → Select your instance

Scroll to Storage → click the Volume ID

Step 2 — Modify Volume

Change size from 8 GiB → 20 GiB (safe minimum)

sudo growpart /dev/nvme0n1 1
CHANGED: partition=1 start=227328 old: size=16549855 end=16777183 new: size=41715679 end=41943007
ubuntu@ip-172-31-23-153:~$ sudo resize2fs /dev/nvme0n1p1
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/nvme0n1p1 is mounted on /; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 3
The filesystem on /dev/nvme0n1p1 is now 5214459 (4k) blocks long.

df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root         20G  6.6G   13G  35% /


`minikube start` after reloading EC2:

```bash
sudo nano /etc/systemd/system/minikube.service
```

Put this inside:

Create a minimal systemd service - what are these??

[Unit]
Description=Start Minikube at boot
After=network.target docker.service

[Service]
Type=oneshot
User=ubuntu
ExecStart=/usr/local/bin/minikube start

[Install]
WantedBy=multi-user.target

EXPLAINNN ALL THE LINES OF CODE WITH # UNDER NEATH EACH LINE

Then run:

```bash
sudo systemctl daemon-reload
sudo systemctl enable minikube.service

```

EXPLAIN

This service does not start the tunnel, because the tunnel requires:

sudo

environment inheritance (-E)

interactive routing

EXPLAIN

log out of ec2 and back in

### 3) Check Minikube Status
kubectl get nodes

**Expected result:**
The node should show:
Ready control-plane

nginx
Copy code

This confirms **Minikube started automatically** on boot.

### 4) Start the Tunnel (manual step)
sudo -E minikube tunnel

This part is always manual because the tunnel:
- requires root privileges
- modifies routing on the host

Stress test:

sudo apt install apache2-utils
get minikube ip
ab -n 20000 -c 50 http://minikubeip:<nodePort>/

