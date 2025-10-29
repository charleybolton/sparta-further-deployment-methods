A work in progress...


Day 3


Task: Setup minikube on a cloud instance running Ubuntu 22.04 LTS

Aim: Get minikube running on a cloud instance

· Use a cloud instance, either

o An AWS EC2 instance (size: t3a.small) or

o An Azure VM (size: standard_b2pls)

· Image: Ubuntu 22.04 LTS


Task: Deploy on three apps on one cloud instance running minikube

· Aim: Deploy three apps on minikube that will all run at the same time and be exposed to the outside world at different endpoints

· Rationale:

· Consolidate the skills already learnt

· Develop understanding that will help deployment of Sparta test app (to be done in a later task)

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

· In your documentation, include:

o Specifics on how and why use minikube tunnel

o How you cleanup and remove each deployment

o How to get Kubernetes working again after restarting the cloud instance


Task: Use Kubernetes to deploy the Sparta test app in the cloud

· Deploy containerised 2-tier deployment (app and database) on a single VM using Minikube

· Database should use a PV of 100 MB

· Use HPA to scale the app, min 2, max 10 replicas - load test to check it works

· Use NodePort service and Nginx reverse proxy to expose the app service to port 80 of the instance's public IP

· Make sure that `minikube start` happens automatically on re-start of the instance