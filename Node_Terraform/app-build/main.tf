resource "null_resource" "build" {
  triggers = {
    always = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOF
cd ${path.root}/app-source-code
aws ecr get-login-password | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com
docker build -t ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/demo-app:latest .
docker push ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/demo-app:latest
EOF
  }
}
