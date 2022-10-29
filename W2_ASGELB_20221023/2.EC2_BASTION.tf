######################################## Bastion EC2

#################### EIP
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
  vpc      = true

  tags = {
    Name = format(
      "%s-%s-bastion-eip",
      var.title,var.subtitle
    )
  } 
}

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
      "%s-%s-bastion-sg",
      var.title,var.subtitle
    )
  description = format(
      "%s-%s-bastion-sg",
      var.title,var.subtitle
    )
  tags = {
    Name = format(
      "%s-%s-bastion-sg",
      var.title,var.subtitle
    )
  }
}

#################### EC2
resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.BASTION
  subnet_id     = aws_subnet.vpc_public[0].id
  key_name      = var.key_pair
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  associate_public_ip_address = true
  
  #user_data     = data.template_file.web-userdata.rendered

  root_block_device {
    volume_type               = "gp3"
    volume_size               = var.BASTION_VOL
    delete_on_termination     = true
  }
  tags = {
    Name = format(
      "%s-%s-bastion",
      var.title,var.subtitle
    )
  }  
}

