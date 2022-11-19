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
      var.tags.Environment == null ? format("%s-%s-bastion-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-bastion-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
  )  
  description = format(
      var.tags.Environment == null ? format("%s-%s-bastion-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-bastion-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
  )
  tags = {
    Name = format(
      var.tags.Environment == null ? format("%s-%s-bastion-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-bastion-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
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
      var.tags.Environment == null ? format("%s-%s-bastion", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-bastion", var.tags.Project,var.tags.Environment,var.tags.Owner)
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
      var.tags.Environment == null ? format("%s-%s-bastion-eip", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-bastion-eip", var.tags.Project,var.tags.Environment,var.tags.Owner)
    )
  }    
}