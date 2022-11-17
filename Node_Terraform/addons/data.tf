data "aws_eks_cluster" "eks" {
  name = "${var.env}-eks-cluster"
}


data "aws_caller_identity" "current" {}

