######################################## VPC
resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr
  instance_tenancy = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  tags = {
    Name = format(
      var.tags.Environment == null ? "${var.tags.Project}-${var.tags.Owner}-vpc" : "${var.tags.Project}-${var.tags.Environment}-${var.tags.Owner}-vpc")
  }
}

######################################## IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format(
      var.tags.Environment == null ? "${var.tags.Project}-${var.tags.Owner}-igw" : "${var.tags.Project}-${var.tags.Environment}-${var.tags.Owner}-igw")
  }
}

######################################## NAT GW
resource "aws_eip" "nat_gw" {
  vpc = true
  tags = {
    Name = format(
      var.tags.Environment == null ? "${var.tags.Project}-${var.tags.Owner}-nat-eip" : "${var.tags.Project}-${var.tags.Environment}-${var.tags.Owner}-nat-eip")
  }
}
resource "aws_nat_gateway" "nat_gw" {
  depends_on = [aws_eip.nat_gw]

  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.vpc_public[0].id

  tags = {
    Name = format(
      var.tags.Environment == null ? "${var.tags.Project}-${var.tags.Owner}-natgw" : "${var.tags.Project}-${var.tags.Environment}-${var.tags.Owner}-natgw")
  }
}

######################################## SUBNET
resource "aws_subnet" "vpc_public"  {
  count = length(local.public_subnets_vpc)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.public_subnets_vpc[count.index].cidr
  availability_zone = local.public_subnets_vpc[count.index].zone
  tags = {
    Name = format(
      var.tags.Environment == null 
      ? format("%s-%s-%s-%s", var.tags.Project,var.tags.Owner,local.public_subnets_vpc[count.index].purpose,element(split("", local.public_subnets_vpc[count.index].zone), length(local.public_subnets_vpc[count.index].zone) - 1))
      : format("%s-%s-%s-%s-%s", var.tags.Project,var.tags.Environment,var.tags.Owner,local.public_subnets_vpc[count.index].purpose,element(split("", local.public_subnets_vpc[count.index].zone), length(local.public_subnets_vpc[count.index].zone) - 1))
    )
  }  
}
resource "aws_subnet" "vpc_private_web" {
  count = length(local.private_subnets_vpc_web)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.private_subnets_vpc_web[count.index].cidr
  availability_zone = local.private_subnets_vpc_web[count.index].zone
  tags = {
    Name = format(
      var.tags.Environment == null 
      ? format("%s-%s-%s-%s", var.tags.Project,var.tags.Owner,local.private_subnets_vpc_web[count.index].purpose,element(split("", local.private_subnets_vpc_web[count.index].zone), length(local.private_subnets_vpc_web[count.index].zone) - 1))
      : format("%s-%s-%s-%s-%s", var.tags.Project,var.tags.Environment,var.tags.Owner,local.private_subnets_vpc_web[count.index].purpose,element(split("", local.private_subnets_vpc_web[count.index].zone), length(local.private_subnets_vpc_web[count.index].zone) - 1))
    )
  }    
}
resource "aws_subnet" "vpc_private_db" {
  count = length(local.private_subnets_vpc_db)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = local.private_subnets_vpc_db[count.index].cidr
  availability_zone = local.private_subnets_vpc_db[count.index].zone
  tags = {
    Name = format(
      var.tags.Environment == null 
      ? format("%s-%s-%s-%s", var.tags.Project,var.tags.Owner,local.private_subnets_vpc_db[count.index].purpose,element(split("", local.private_subnets_vpc_db[count.index].zone), length(local.private_subnets_vpc_db[count.index].zone) - 1))
      : format("%s-%s-%s-%s-%s", var.tags.Project,var.tags.Environment,var.tags.Owner,local.private_subnets_vpc_db[count.index].purpose,element(split("", local.private_subnets_vpc_db[count.index].zone), length(local.private_subnets_vpc_db[count.index].zone) - 1))
    )
  }      
}

######################################## RT
resource "aws_route_table" "vpc_public" {
  depends_on = [aws_internet_gateway.igw] 
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = format(
      var.tags.Environment == null 
      ? format("%s-%s-rt-%s", var.tags.Project,var.tags.Owner,local.public_subnets_vpc[0].purpose)
      : format("%s-%s-%s-rt-%s", var.tags.Project,var.tags.Environment,var.tags.Owner,local.public_subnets_vpc[0].purpose)
    )
  }  
}
resource "aws_route_table_association" "vpc_public" {
  count = length(aws_subnet.vpc_public)
  subnet_id      = aws_subnet.vpc_public[count.index].id
  route_table_id = aws_route_table.vpc_public.id
}

resource "aws_route_table" "vpc_private_web" {
  depends_on = [aws_nat_gateway.nat_gw] 
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = format(
      var.tags.Environment == null 
      ? format("%s-%s-rt-%s-web", var.tags.Project,var.tags.Owner,local.private_subnets_vpc_web[0].purpose)
      : format("%s-%s-%s-rt-%s-web", var.tags.Project,var.tags.Environment,var.tags.Owner,local.private_subnets_vpc_web[0].purpose)
    )
  }      
}
resource "aws_route_table_association" "vpc_private_web" {
  count = length(aws_subnet.vpc_private_web)
  subnet_id      = aws_subnet.vpc_private_web[count.index].id
  route_table_id = aws_route_table.vpc_private_web.id
}

resource "aws_route_table" "vpc_private_db" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = format(
      var.tags.Environment == null 
      ? format("%s-%s-rt-%s-db", var.tags.Project,var.tags.Owner,local.private_subnets_vpc_db[0].purpose)
      : format("%s-%s-%s-rt-%s-db", var.tags.Project,var.tags.Environment,var.tags.Owner,local.private_subnets_vpc_db[0].purpose)
    )
  }    
}
resource "aws_route_table_association" "vpc_private_db" {
  count = length(aws_subnet.vpc_private_db)
  subnet_id      = aws_subnet.vpc_private_db[count.index].id
  route_table_id = aws_route_table.vpc_private_db.id
}