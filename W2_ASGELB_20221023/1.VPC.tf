######################################## VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  instance_tenancy = var.instance_tenancy
  tags = {
      Name = format(
        "%s-%s-vpc-testbackend",
        var.title,var.subtitle
      )
  }
}

######################################## IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
      Name = format(
        "%s-%s-igw",
        var.title,var.subtitle
      )
  }
}

######################################## NAT
resource "aws_eip" "nat_gw" {
  vpc = true
  tags = {
      Name = format(
        "%s-%s-nat-eip",
        var.title,var.subtitle
      )
  }  
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.vpc_public[1].id

  tags = {
      Name = format(
        "%s-%s-nat",
        var.title,var.subtitle
      )
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
         "%s-%s-%s-%s",
         var.title,var.subtitle,
         local.public_subnets_vpc[count.index].purpose,
         element(split("", local.public_subnets_vpc[count.index].zone), length(local.public_subnets_vpc[count.index].zone) - 1)
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
         "%s-%s-%s-%s",
         var.title,var.subtitle,
         local.private_subnets_vpc_web[count.index].purpose,
         element(split("", local.private_subnets_vpc_web[count.index].zone), length(local.private_subnets_vpc_web[count.index].zone) - 1)
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
        "%s-%s-vpc-rt-pub",
        var.title,var.subtitle
    )
  }
}
resource "aws_route_table_association" "vpc_public" {
  count = length(aws_subnet.vpc_public)
  subnet_id      = aws_subnet.vpc_public[count.index].id
  route_table_id = aws_route_table.vpc_public.id
}

##
resource "aws_route_table" "vpc_private" {
  depends_on = [aws_nat_gateway.nat_gw] 
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = format(
        "%s-%s-vpc-rt-pri-web",
        var.title,var.subtitle
    )
  }
}
resource "aws_route_table_association" "vpc_private" {
  count = length(aws_subnet.vpc_private_web)
  subnet_id      = aws_subnet.vpc_private_web[count.index].id
  route_table_id = aws_route_table.vpc_private.id
}