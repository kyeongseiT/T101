############################## Input locals
############################## subneting of VPC

locals {
  public_subnets_vpc = [
    {
      purpose = "pub"
      zone = "${var.region}a" ## Must be put a AZs alphabet
      cidr = "10.224.0.0/24"
    },
    {
      purpose = "pub"
      zone = "${var.region}c" ## Must be put a AZs alphabet
      cidr = "10.224.1.0/24"
    }
  ]
}