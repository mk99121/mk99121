resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name 
  node_group_name = var.node-group
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = module.vpc.private_subnets
  version = var.cluster-version


  ami_type = var.ami_type
  disk_size = var.disk_size
  instance_types = var.instance_type
  capacity_type = var.capacity_type

  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 1
  }
  tags = {
      "Name" = "MyEKSNode"
      # Add any other tags you may need
    }
  
  update_config {
    max_unavailable = 1
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


