######################################## WEB EC2

#################### web EC2 security group
resource "aws_security_group" "web" {
  vpc_id = aws_vpc.vpc.id

  ingress { #SSH
    description = "From bastion ssh"
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
      var.tags.Environment == null ? format("%s-%s-web-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-web-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
  )  
  description = format(
      var.tags.Environment == null ? format("%s-%s-web-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-web-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
  )
  tags = {
    Name = format(
      var.tags.Environment == null ? format("%s-%s-web-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-web-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
    )
  }  
}



resource "aws_instance" "web" {
  count = 2
  ami           = data.aws_ami.amz2.id
  associate_public_ip_address = false
  disable_api_termination = var.disable_api_termination
  # iam_instance_profile = aws_iam_instance_profile.ec2s3.name
  instance_type = var.web
  subnet_id     = aws_subnet.vpc_private_web[count.index].id
  key_name      = var.web_key_pair
  vpc_security_group_ids = [aws_security_group.web.id]
  
  # user_data     = data.template_file.web-userdata.rendered
  # user_data_replace_on_change = false

  root_block_device {
    volume_type               = "gp3"
    volume_size               = var.web_vol
    delete_on_termination     = true
  }
  
  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name = format(
      var.tags.Environment == null ? format("%s-%s-web-%s", var.tags.Project,var.tags.Owner,element(split("", aws_subnet.vpc_private_web[count.index].availability_zone), length(aws_subnet.vpc_private_web[count.index].availability_zone) - 1)) : format("%s-%s-%s-web-%s", var.tags.Project,var.tags.Environment,var.tags.Owner,element(split("", aws_subnet.vpc_private_web[count.index].availability_zone), length(aws_subnet.vpc_private_web[count.index].availability_zone) - 1))
    )
  }   
}
