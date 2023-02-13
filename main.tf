module "netowrk" {
  source = "github.com/kirankumar7163/tf-module-vpc"

  for_each = var.vpc
    cidr_block = each.value.cidr_block
}

