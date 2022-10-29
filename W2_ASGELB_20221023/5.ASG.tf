resource "aws_launch_configuration" "mylauchconfig" {
  name_prefix     = "t101-lauchconfig-"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.pub-alb-sg.id]
  associate_public_ip_address = true

#   user_data     = data.template_file.web-userdata.rendered
  user_data = <<-EOF
              #!/bin/bash
              wget https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-x86_64
              mv busybox-x86_64 busybox
              chmod +x busybox
              RZAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
              IID=$(curl 169.254.169.254/latest/meta-data/instance-id)
              LIP=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
              echo "<h1>RegionAz($RZAZ) : Instance ID($IID) : Private IP($LIP) : Web Server</h1>" > index.html
              nohup ./busybox httpd -f -p 80 &
              EOF
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