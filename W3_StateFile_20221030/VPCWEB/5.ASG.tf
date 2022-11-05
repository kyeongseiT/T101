
data "template_file" "web-userdata" {
  template = file("./userdata/web.sh")

  vars = {
    server_port = 8080
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  }
}
resource "aws_launch_configuration" "mylauchconfig" {
  name_prefix     = "t101-lauchconfig-"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.pub-alb-sg.id]
  associate_public_ip_address = true

#   user_data     = data.template_file.web-userdata.rendered

  # Render the User Data script as a template
  user_data = templatefile("./userdata/web.sh", {
    server_port = 8080
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
  })
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "myasg" {
  name                 = "myasg"
  launch_configuration = aws_launch_configuration.mylauchconfig.name
  vpc_zone_identifier  = [aws_subnet.vpc_private_web[0].id, aws_subnet.vpc_private_web[1].id]
  #subnet_id     = aws_subnet.vpc_private_web[0].id
  min_size = 2
  max_size = 10
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.pub-alb-80.arn]

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}