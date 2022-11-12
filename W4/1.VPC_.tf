######################################## VPC
resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr
  instance_tenancy = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  tags = {
      Name = format(
        "%s-%s-%s-vpc",
        var.title,var.environments,var.subtitle
      )
  }
}

######################################## IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
      Name = format(
        "%s-%s-%s-igw",
        var.title,var.environments,var.subtitle
      )
  }
}

######################################## NAT GW
resource "aws_eip" "nat_gw" {
  vpc = true
  tags = {
      Name = format(
        "%s-%s-%s-nat-eip",
        var.title,var.environments,var.subtitle
      )
  }  
}
resource "aws_nat_gateway" "nat_gw" {
  depends_on = [aws_eip.nat_gw]

  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.vpc_public[0].id

  tags = {
      Name = format(
        "%s-%s-%s-natgw",
        var.title,var.environments,var.subtitle
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
         "%s-%s-%s-%s-%s",
         var.title,var.environments,var.subtitle,
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
         "%s-%s-%s-%s-%s",
         var.title,var.environments,var.subtitle,
         local.private_subnets_vpc_web[count.index].purpose,
         element(split("", local.private_subnets_vpc_web[count.index].zone), length(local.private_subnets_vpc_web[count.index].zone) - 1)
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
         "%s-%s-%s-%s-%s",
         var.title,var.environments,var.subtitle,
         local.private_subnets_vpc_db[count.index].purpose,
         element(split("", local.private_subnets_vpc_db[count.index].zone), length(local.private_subnets_vpc_db[count.index].zone) - 1)
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
        "%s-%s-%s-vpc-rt-pub",
        var.title,var.environments,var.subtitle
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
        "%s-%s-%s-vpc-rt-pri-web",
        var.title,var.environments,var.subtitle
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
        "%s-%s-%s-vpc-rt-pri-db",
        var.title,var.environments,var.subtitle
    )
  }
}
resource "aws_route_table_association" "vpc_private_db" {
  count = length(aws_subnet.vpc_private_db)
  subnet_id      = aws_subnet.vpc_private_db[count.index].id
  route_table_id = aws_route_table.vpc_private_db.id
}