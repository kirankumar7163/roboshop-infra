module "vpc" {
  source            = "github.com/kirankumar7163/tf-module-vpc"
  env               = var.env
  default_vpc_id    = var.default_vpc_id

  for_each                = var.vpc
  cidr_block              = each.value.cidr_block
  public_subnets          = each.value.public_subnets
  private_subnets         = each.value.private_subnets
  availability_zone       = each.value.availability_zone
}

module "docdb" {
  source = "github.com/kirankumar7163/tf-module-docdb"
  env    = var.env

  for_each   = var.docdb
  subnet_ids = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id     = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  engine_version = each.value.engine_version
  number_of_instances = each.value.number_of_instances
  instance_class = each.value.instance_class
}

module "RDS" {
  source = "github.com/kirankumar7163/tf-module-RDS"
  env    = var.env

  for_each             = var.rds
  subnet_ids           = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id               = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr           = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  engine_version       = each.value.engine_version
  engine               = each.value.engine
  number_of_instances  = each.value.number_of_instances
  instance_class       = each.value.instance_class
}

module "elasticache" {
  source = "github.com/kirankumar7163/tf-module-elasticache"
  env    = var.env

  for_each        = var.elasticache
  subnet_ids      = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id          = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr      = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  num_cache_nodes = each.value.num_cache_nodes
  node_type       = each.value.node_type
  engine_version  = each.value.engine_version
}

module "rabbitmq" {
  source              = "github.com/kirankumar7163/tf-module-rabbitmq"
  env                 = var.env
  bastion_cidr        = var.bastion_cidr

  for_each             = var.rabbitmq
  subnet_ids           = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id               = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr           = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  engine_version       = each.value.engine_version
  engine_type          = each.value.engine_type
  host_instance_type   = each.value.host_instance_type
  deployment_mode      = each.value.deployment_mode

}

module "alb" {
  source = "github.com/kirankumar7163/tf-module-alb"
  env    = var.env

  for_each             = var.alb
  subnet_ids           = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id               = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr           = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)
  subnets_name         = each.value.subnets_name
  internal             = each.value.internal


}


module "apps" {
  source = "github.com/kirankumar7163/tf-module-app"
  env    = var.env

  depends_on = [module.docdb, module.RDS, module.elasticache, module.rabbitmq, module.alb]
  for_each     = var.apps
  subnet_ids   = lookup(lookup(lookup(lookup(module.vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_ids", null)
  vpc_id       = lookup(lookup(module.vpc, each.value.vpc_name, null), "vpc_id", null)
  allow_cidr   = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), each.value.allow_cidr_subnets_type, null), each.value.allow_cidr_subnets_name, null), "cidr_block", null)
  component    = each.value.component
  app_port     = each.value.app_port
  max_size     = each.value.max_size
  min_size     = each.value.min_size
  desired_capacity = each.value.desired_capacity
  instance_type = each.value.instance_type
  bastion_cidr  = var.bastion_cidr


}

