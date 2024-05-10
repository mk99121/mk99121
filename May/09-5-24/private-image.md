Private Image

to create a Pod that uses a Secret to pull an image from a private container image registry

create a Secret by providing Docker credentials
kubectl create secret docker-registry demo --docker-server=https://index.docker.io/v1/ --docker-username=krishna0011 --docker-password=***** --docker-email=mohankrishna@gmail.com

you need to call this in your deployment

for example tomcat deployment

apiVersion: apps/v1
kind: Deployment
metadata:
  name: tomcat-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: tomcat
  template:
    metadata:
      labels:
        app: tomcat
    spec:
      containers:
      - name: tomcat
        image: krishna0011/vproapp:v1
        ports:
        - containerPort: 8080
      imagePullSecrets:
      - name: demo

Now u can check the status of the pod deployment
                         



        