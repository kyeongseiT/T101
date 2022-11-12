######################################## Bastion
#################### SG
resource "aws_security_group" "bastion-sg" {
  vpc_id = aws_vpc.vpc.id

  ingress { #SSH
    description = "From kyeongsei home ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip_addrs]
  } 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = format(
      "%s-%s-%s-bastion-sg",
      var.title,var.environments,var.subtitle
    )
  description = format(
      "%s-%s-%s-bastion-sg",
      var.title,var.environments,var.subtitle
    )
  tags = {
    Name = format(
      "%s-%s-%s-bastion-sg",
      var.title,var.environments,var.subtitle
    )
  }
}

#################### EC2 Bastion
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amz2.id
  instance_type = var.bastion
  subnet_id     = aws_subnet.vpc_public[0].id
  key_name      = var.bastion_key_pair
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  associate_public_ip_address = true
  
  root_block_device {
    volume_type               = "gp3"
    volume_size               = var.bastion_vol
    delete_on_termination     = true
  }
  lifecycle {
    ignore_changes = [ami]
  }
  tags = {
    Name = format(
      "%s-%s-%s-bastion",
      var.title,var.environments,var.subtitle
    )
  }  
}


#################### Bastion EIP
resource "aws_eip" "bastion_eip" {
  depends_on = [aws_instance.bastion]
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name = format(
      "%s-%s-%s-bastion-eip",
      var.title,var.environments,var.subtitle
    )
  } 
}