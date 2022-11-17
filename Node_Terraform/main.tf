module "vpc" {
  source     = "./vpc"
  for_each   = var.vpc
  cidr_block = each.value.cidr_block
  subnets    = each.value.subnets
  env        = var.env
  AZ         = var.AZ
}

module "eks" {
  source             = "./eks"
  env                = var.env
  PRIVATE_SUBNET_IDS = module.vpc["main"].subnets["apps"].subnet_ids
  PUBLIC_SUBNET_IDS  = module.vpc["main"].subnets["public"].subnet_ids
  for_each           = var.eks
  size               = each.value.size
  type               = each.value.type
  node               = each.value.node
  eks_version        = each.value.version
}

module "eks-addons" {
  depends_on         = [module.eks]
  source             = "./addons"
  create_alb_ingress = true
  env                = var.env
  PRIVATE_SUBNET_IDS = module.vpc["main"].subnets["apps"].subnet_ids
  PUBLIC_SUBNET_IDS  = module.vpc["main"].subnets["public"].subnet_ids
}

module "app-build" {
  depends_on = [module.eks]
  source     = "./app-build"
}

module "app-deploy" {
  depends_on = [module.eks, module.app-build, module.eks-addons]
  source     = "./app-deploy"
}
