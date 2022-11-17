resource "null_resource" "deploy-helm-chart" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOF
aws ecr create-repository --repository-name demo-app --region=us-east-1 || true
helm upgrade -i demo-app ${path.module}/helm --set-string imageFullName=${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/demo-app
EOF
  }
}

data "aws_caller_identity" "current" {}

