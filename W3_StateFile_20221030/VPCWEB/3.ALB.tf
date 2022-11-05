######################################## ALB

#################### ALB SG
resource "aws_security_group" "pub-alb-sg" {
  name = format(
      "%s-%s-was-pub-alb-sg",
      var.title,var.subtitle
    )  

  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "From Client 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "From Client 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = format(
      "%s-%s-pub-alb-sg",
      var.title,var.subtitle
    )
  }
}

######################################## ALB
resource "aws_lb" "pub-alb" {
  name = format(
      "%s-%s-pub-alb",
      var.title,var.subtitle
  )  
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.pub-alb-sg.id ]
  subnets            = aws_subnet.vpc_public.*.id
  enable_deletion_protection = true

  tags = {
    Name = format(
      "%s-%s-pub-alb",
      var.title,var.subtitle
    )
  }  
}

######################################## LB listner
resource "aws_lb_listener" "pub-alb-80" {
  load_balancer_arn = aws_lb.pub-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "pub-alb-443" {
  load_balancer_arn = aws_lb.pub-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.kyeongsei-xyz.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub-alb-80.arn
  }
}

######################################## ALB TG
resource "aws_lb_target_group" "pub-alb-80" {
  name = format(
      "%s-%s-pub-alb-tg80",
      var.title,var.subtitle
    )  
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

######################################## LB TG Attach
# resource "aws_lb_target_group_attachment" "pub-alb" {
#   target_group_arn = aws_lb_target_group.pub-alb-80.arn
#   target_id        = aws_instance.was.id                    
#   port             = 80
# }




