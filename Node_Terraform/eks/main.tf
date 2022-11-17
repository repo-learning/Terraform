resource "aws_eks_cluster" "eks" {
  name     = "${var.env}-eks-cluster"
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = var.PRIVATE_SUBNET_IDS
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "tf-nodes-spot"
  node_role_arn   = aws_iam_role.eks-node-role.arn
  subnet_ids      = var.PRIVATE_SUBNET_IDS
  capacity_type   = var.type
  instance_types  = var.node

  scaling_config {
    desired_size = var.size
    max_size     = var.size
    min_size     = var.size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy-attach,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy-attach,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly-attach,
  ]
}

