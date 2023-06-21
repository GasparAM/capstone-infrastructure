variable "ingress_ips" {}

variable "cidr_block_vpc" {}

variable "tags" {}

locals {
  subnetcalc = cidrsubnets(var.cidr_block_vpc, 8, 8, 8, 8, 8)
  privsubs   = element(chunklist(local.subnetcalc, 3), 1)
  pubsubs   = element(chunklist(local.subnetcalc, 3), 0)
  subnets_private = {
    "private-a" = {
      cidr_block        = local.privsubs[0]
      availability_zone = "eu-north-1a"
    }
    "private-b" = {
      cidr_block = local.privsubs[1]
      availability_zone = "eu-north-1b"
    }
    # "private-c" = {
    #   cidr_block = local.privsubs[2]
    #   availability_zone = "en-north-1c"
    # }
  }
  subnets_public = {
    "public-a" = {
      cidr_block        = local.pubsubs[0]
      availability_zone = "eu-north-1a"
    }
    "public-b" = {
      cidr_block = local.pubsubs[1]
      availability_zone = "eu-north-1b"
    }
    "public-c" = {
      cidr_block = local.pubsubs[2]
      availability_zone = "eu-north-1c"
    }
  }
}