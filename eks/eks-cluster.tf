resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.master.arn
  version = var.cluster-version

  vpc_config {
    subnet_ids = module.vpc.private_subnets
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs    = var.my_ip
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]

#Enable EKS cluster control plane Logging
enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

}