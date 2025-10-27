A work in progress... 
Day 2


Task: Create 2-tier deployment with PV for database

Pre-requisite: You have the NodeJS app and MongoDB database working on Kubernetes, but you are not using a PV (persistent volume) yet for the database.

1. Create your app and database deployment, but for the database include a volume (PV and PVC).

a. Be careful you don't allocate too much storage for the PV

b. Remember to remove PV at the end (otherwise they will just stay there)

c. Check them using these commands:


kubectl get pv

kubectl get pvc


You will know you are successful if you:

1. Delete the database deployment or the database pod

2. Re-create the database deployment or pod

3. The same data displays on the /posts page.


2. Diagram your Kubernetes architecture with the PV and PVC

a. Have logical notes/dot points on your diagram, labels


Links to help: · https://kubernetes.io/docs/concepts/storage/persistent-volumes/



Task: Research types of autoscaling with K8s

· Research and document the types of autoscaling available with K8s

· Duration: 10-15 min


Task: Use Horizontal Pod Autoscaler (HPA) to scale the app

· Scale only the app (minimum 2, maximum 10 replicas)

· Test your scaler works by load testing

o You could use Apache Bench (ab) for load testing


(Extension – if time) Task: Remove PVC and retain data in Persistent Volume

Pre-requisite: You have the NodeJS app and MongoDB database working on Kubernetes with PV and PVC for the Mongo database deployment.


1. Test out your PV and PVC

a. Delete the PV and PVC
b. Re-create your PV and PVC and see if your data was retained (same data from the previous PV)

2. If the data has been wiped, work on modifying your PV and PVC to retain the data


You may first wish to duplicate your previous work, then work on this task.


Links to help: · https://kubernetes.io/docs/tasks/administer-cluster/change-pv-reclaim-policy/ · https://kubernetes.io/docs/concepts/storage/persistent-volumes/