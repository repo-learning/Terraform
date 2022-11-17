This is a monorepo that has all terraform modules, Application Repo, & Helm Chart to Deploy.

Following are the security considerations that was made while making this setup. 

Infra:
------

1. A Separate VPC. 
2. Public and Private Subnets with two AZ for HA. 
3. K8S Cluster running in Private Subnets. 
4. Application is exposed over ingress.
5. WAF Attached to Ingress to Protect Application.

Application:
-------

1. Create Docker Image with minimal Nodejs modules. 
2. Run the container as nonroot user. 


Steps to setup this:
-------

PRE-REQUISITES:
----

1. Makefile 
2. Terraform >= 1.2.8
3. Docker >= 20.10.17
4. Helm >= 3.10.2
5. kubectl
6. kubergrunt 0.9.3

Setup steps:
----
1. Configure AWS Creds with `aws configure`
2. `make terraform-apply` - To Configure end to end application
3. `make terraform-destroy` - To Destroy end to end application


Things can be improved.
----

1. Shell script to install pre requisites
2. Remote Terraform S3 statefile with DynamoDB locking 
3. Secret Management with AWS Secret Manager 
4. Parameters with AWS Parameter Store 
5. Enable https with ALB over ingress 
6. Enable AWS WAF over ALB.
7. Container to run as nonroot user
