AWS EKS: IRSA(IAM Roles for Service Accounts):
To access aws services from workloads work load ruuning in eks cluster (nothing but pods) we need IRSA 
For example: EBS CSI Controller, we can resize, create,delete,retain the amazon ebs volumes from k8s resources in eks cluster using k8's StorageClasses,pvc,pv
EBS CSI Controller, we can map EFS filesystem to our k8s pods in our EKS Cluster.
External DNS Controller,we can create,delete,update "AWS Route 53" DNS records using External DNS
Ingress controller:
Aws load-balancer controller, we can create AWS Application,Network load-balancer with all the srttings from our eks cluster using k8s ingress resource

KEY ITEMS FOR IRSA IMPLEMENTATION:
1:AWS IAM Identity Provider
2:AWS STS(security token service)
3:AWS IAM temparory role credentials

From EKS Cluster:
1:Openid connect provider
2:Service accounts

EKS Cluster acts as an openid connect provider(it can act as External identity provider to AWS IAM)
EKS Cluster contains the OpenID Connect provider issuer URl
we can  configure this openid connect issuer URL in AWS IAM Identity Provider

AWS IAM Role for k8's Service accounts:

