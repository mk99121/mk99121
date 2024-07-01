

data "aws_partition" "current" {}

# Resource: AWS IAM Open ID Connect Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer

  tags = merge(
    {
      Name = "${var.cluster-name}-eks-irsa"
    },
  )
  depends_on = [aws_eks_cluster.eks-cluster]
}

