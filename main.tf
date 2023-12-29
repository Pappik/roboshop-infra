module "vpc" {
  source = "github.com/Pappik/tf-module-vpc"
  env = var.env
  default_vpc_id = var.default_vpc_id


  for_each = var.vpc
  cidr_block = each.value.cidr_block
  subnets_cidr = each.value.subnets_cidr
  }