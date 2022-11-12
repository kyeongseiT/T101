############################## Input locals

#################################subneting of VPC
locals {
  vpc_cidr = "10.224.0.0/16"

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
private_subnets_vpc_web = [
    {
      purpose = "pri-web"
      zone = "${var.region}a" ## Must be put a AZs alphabet
      cidr = "10.224.10.0/24"
    },
    {
      purpose = "pri-web"
      zone = "${var.region}c" ## Must be put a AZs alphabet
      cidr = "10.224.11.0/24"
    }
  ]  
private_subnets_vpc_db = [
    {
      purpose = "pri-db"
      zone = "${var.region}a" ## Must be put a AZs alphabet
      cidr = "10.224.20.0/24"
    },
    {
      purpose = "pri-db"
      zone = "${var.region}c" ## Must be put a AZs alphabet
      cidr = "10.224.21.0/24"
    }
  ]    
}