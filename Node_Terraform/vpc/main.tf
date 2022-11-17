resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-vpc"
  }
}

module "subnets" {
  for_each = var.subnets
  source   = "./subnets"
  name     = each.value["name"]
  subnets  = each.value["subnet_cidr"]
  vpc_id   = aws_vpc.main.id
  AZ       = var.AZ
  env      = var.env
}

module "routes" {
  for_each       = var.subnets
  source         = "./routes"
  vpc_id         = aws_vpc.main.id
  name           = each.value["name"]
  subnet_ids     = module.subnets
  gateway_id     = aws_internet_gateway.igw.id
  nat_gateway_id = aws_nat_gateway.ngw.id
  ngw            = try(each.value["ngw"], false)
  igw            = try(each.value["igw"], false)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_eip" "ngw" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = module.subnets["public"].subnets[0].id

  tags = {
    Name = "gw NAT"
  }
}


