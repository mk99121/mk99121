# Resource: Kubernetes Service Account
resource "kubernetes_service_account_v1" "aws-lbc" {
  depends_on = [ aws_iam_role_policy_attachment.lbc_iam_role_policy_attach ]
  metadata {
    name = "irsa-demo-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.lbc_iam_role.arn


      }
  }
}

#
# Deploy Kubernetes Pod with the Service Account that can assume an AWS IAM role
#
resource "kubernetes_pod" "iam_role_test" {
  metadata {
    name      = "aws-lbc"
    namespace = "kube-system"
  }

  spec {
    service_account_name = "aws-lbc"
    container {
      name  = "iam-role-test"
      image = "amazon/aws-cli:latest"
      # Sleep so that the container stays alive
      # #continuous-sleeping
      command = ["/bin/bash", "-c", "--"]
      args    = ["while true; do sleep 5; done;"]
    }
  }
}