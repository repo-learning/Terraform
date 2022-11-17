resource "null_resource" "get-kube-config" {
  provisioner "local-exec" {
    #configures kubectl to connect to EKS cluster
    command = "aws eks update-kubeconfig  --name ${var.env}-eks-cluster"
  }
}


