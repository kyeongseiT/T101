######################################## WAS EC2

#################### WAS EC2 SG
resource "aws_security_group" "was-sg" {
  vpc_id = aws_vpc.vpc.id

  ingress { #SSH
    description = "From kyeongsei home ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups    = [aws_security_group.bastion-sg.id]
  } 
  ingress { 
    description = "From pub alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups    = [aws_security_group.pub-alb-sg.id]
  }   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = format(
      "%s-%s-was-SG",
      var.title,var.subtitle
    )
  description = format(
      "%s-%s-was-SG",
      var.title,var.subtitle
    )
  tags = {
    Name = format(
      "%s-%s-was-SG",
      var.title,var.subtitle
    )
  }
}



resource "aws_instance" "was" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.WAS
  subnet_id     = aws_subnet.vpc_private_web[0].id
  key_name      = var.key_pair
  vpc_security_group_ids = [aws_security_group.was-sg.id]
  associate_public_ip_address = false
  
  user_data     = data.template_file.web-userdata.rendered
  # user_data_replace_on_change = true

  root_block_device {
    volume_type               = "gp3"
    volume_size               = var.WAS_VOL
    delete_on_termination     = true
  }
  tags = {
    Name = format(
      "%s-%s-was",
      var.title,var.subtitle
    )
  }  
}
