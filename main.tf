module "vpc" {
  source = "github.com/Pappik/tf-module-vpc"
  env = var.env
  default_vpc_id = var.default_vpc_id


  for_each = var.vpc
  cidr_block = each.value.cidr_block
  public_subnets    = each.value.public_subnets
  private_subnets    = each.value.private_subnets
  availability_zone = each.value.availability_zone
}

module "docdb" {
  source = "github.com/Pappik/tf-module-docdb"
  env    = var.env

  for_each = var.docdb
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null),each.value.subnets_name, null),"subnet_ids", null)
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
 allow_cidr = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null), "app", null),"cidr_block", null)
  engine_version = each.value.engine_version
  number_of_instances   = each.value.number_of_instances
  instance_class        = each.value.instance_class
}


module "rds" {
  source = "github.com/Pappik/tf-module-rds"
  env    = var.env

  for_each = var.rds
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null),each.value.subnets_name, null),"subnet_ids", null)
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null), "app", null),"cidr_block", null)
  engine = each.value.engine
  engine_version = each.value.engine_version
  number_of_instances   = each.value.number_of_instances
  instance_class        = each.value.instance_class
}

module "elasticache" {
  source = "github.com/Pappik/tf-module-elasticache"
  env    = var.env

  for_each = var.elasticache
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null),each.value.subnets_name, null),"subnet_ids", null)
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null), "app", null),"cidr_block", null)
  num_node_groups         = each.value.num_node_groups
  replicas_per_node_group = each.value.replicas_per_node_group
  node_type    = each.value.node_type
}

module "rabbitmq" {
  source = "github.com/Pappik/tf-module-rabbitmq"
  env    = var.env

  for_each = var.rabbitmq
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null),each.value.subnets_name, null),"subnet_ids", null)
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null), "app", null),"cidr_block", null)
  engine_type = each.value.engine_type
  engine_version = each.value.engine_version
  host_instance_type = each.value.host_instance_type
  deployment_mode = each.value.deployment_mode
}

module "alb" {
  source = "github.com/Pappik/tf-module-alb"
  env    = var.env

  for_each = var.alb
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, "main" , null),each.value.subnets_type, null),each.value.subnets_name, null),"subnet_ids", null)
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr = lookup(lookup(lookup(lookup(module.vpc, "main" , null),"private_subnet_ids", null), "app", null),"cidr_block", null)
 subnets_name = each.value.subnets_name
  internal = each.value.internal
}

module "apps" {
  source = "github.com/Pappik/tf-module-apps"
  env    = var.env

  for_each = var.apps
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, "main" , null),each.value.subnets_type, null),each.value.subnets_name, null),"subnet_ids", null)
  vpc_id = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), each.value.allow_cidr_subnets_type, null), each.value.allow_cidr_subnets_name, null),"cidr_block", null)
  component   = each.value.component
  app_port    = each.value.app_port
  max_size = each.value.max_size
  min_size = each.value.min_size
  desired_capacity = each.value.desired_capacity
  instance_type    = each.value.instance_type
  bastion_cidr  = var.bastion_cidr


}

#output "vpc" {
# value = lookup(lookup(lookup(lookup(module.vpc, "main" , null), "public_subnet_ids", null), "public", null),"cidr_block", null)
#}
