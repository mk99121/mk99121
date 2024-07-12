DEMO 

Document link : https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/

eksctl create cluster --name gkn-cluster --region us-east-1 --fargate --profile ninja

eksctl create cluster --name gkn-cluster --region us-east-1 --fargate --zones us-east-1a,us-east-1b,us-east-1c --profile ninja

eksctl create cluster \
  --name gkn-cluster \
  --region us-east-1 \
  --fargate \
  --zones us-east-1a,us-east-1b,us-east-1c \
  --profile ninja

TO DELETE THE STACK
eksctl-gkn-cluster-cluster --region us-east-1 --profile ninja
aws cloudformation describe-stacks --stack-name eksctl-gkn-cluster-cluster --region us-east-1 --profile ninja

Update kube-config

aws eks update-kubeconfig --name gkn-cluster --region us-easst-1 --profile ninja

To create fargate profile

 eksctl create fargateprofile \
    --cluster gkn-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace game-2048 \
    --profile ninja
	
AWS DEMO :	
https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml
	
	
Now create the resource

OIDC connector
This is the prerequsite before goin to alb adon
we need IAM OIDC connector because the alb ingress controller which is running it needs to access the application load balancer(if the kubernetes resources wanted to talk to aws resources it needs have IAM integrated thats why we need to create OIDC provider,it gives the permission to access)


oidc_id=$(aws eks describe-cluster --name gkn-cluster --region us-east-1 --profile ninja --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5) 

to verify OIDC is has created or not 
aws iam list-open-id-connect-providers --profile ninja

Associate the IAM OIDC identity provider to the cluster
eksctl utils associate-iam-oidc-provider --cluster gkn-cluster --region us-east-1 --profile ninja --approve

We need to create iam policy and attach that role to the eks so that ALB ingress controller pod will communicate with aws API to create application load balancer using the ingress rules we specified 
in the resource.

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json

To create the policy:
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file:///TF/Kubernetes/iam_policy.json \
    --profile ninja
Creting the role:	
eksctl create iamserviceaccount \
  --cluster=gkn-cluster \
  --region=us-east-1 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::361509912577:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --profile ninja \
  --override-existing-serviceaccounts \
  --override-existing-serviceaccounts
  
Now we are using the helm to create alb controller,it will use the service accounts to run the pods 

Download the helm eks repo:
#helm repo add eks https://aws.github.io/eks-charts
check for the any updates to the repo
#helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system \
   --set clusterName=gkn-cluster \
   --set serviceAccount.create=false \
   --set serviceAccount.name=aws-load-balancer-controller \
   --set region=us-east-1 \
   --set vpcId=vpc-0d21ced52504afc1c \
   --set profile=ninja

