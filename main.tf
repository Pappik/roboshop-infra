module "vpc" {
  source = "github.com/Pappik/tf-module-vpc"
  for_each = var.vpc
  cidr_block = each.value.cidr_block
  }