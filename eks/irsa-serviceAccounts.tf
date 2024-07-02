# Resource: Kubernetes Service Account
resource "kubernetes_service_account_v1" "aws-lbc-serviceaccount" {
  depends_on = [ aws_iam_role_policy_attachment.lbc_iam_role_policy_attach ]
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lbc_iam_role.arn


      }
  }
}
resource "kubernetes_service_account_v1" "aws-ebs-serviceaccount" {
  depends_on = [aws_iam_role_policy_attachment.ebs_csi_iam_role_policy_attach ]
  metadata {
    name = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs_csi_iam_role.arn


      }
  }
}
#
# Deploy Kubernetes Pod with the Service Account that can assume an AWS IAM role
#
resource "kubernetes_pod" "iam_role_alb" {

  depends_on = [kubernetes_service_account_v1.aws-lbc-serviceaccount]
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  spec {
    service_account_name = "aws-load-balancer-controller"
    container {
      name  = "iam-role-alb"
      image = "amazon/aws-cli:latest"
      # Sleep so that the container stays alive
      # #continuous-sleeping
      command = ["/bin/bash", "-c", "--"]
      args    = ["while true; do sleep 5; done;"]
    }
  }
}
resource "kubernetes_pod" "iam_role_ebs" {
  depends_on = [ kubernetes_service_account_v1.aws-ebs-serviceaccount ]

  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
  }

  spec {
    service_account_name = "ebs-csi-controller-sa"
    container {
      name  = "iam-role-ebs"
      image = "amazon/aws-cli:latest"
      # Sleep so that the container stays alive
      # #continuous-sleeping
      command = ["/bin/bash", "-c", "--"]
      args    = ["while true; do sleep 5; done;"]
    }
  }
}