######################################## ALB
#################### ALB SG
resource "aws_security_group" "pub-alb-sg" {

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
  name = format(
    var.tags.Environment == null ? format("%s-%s-pub-alb-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-pub-alb-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
  ) 
  description = format(
    var.tags.Environment == null ? format("%s-%s-pub-alb-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-pub-alb-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
  ) 
  tags = {
    Name = format(
      var.tags.Environment == null ? format("%s-%s-pub-alb-sg", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-pub-alb-sg", var.tags.Project,var.tags.Environment,var.tags.Owner)
    )
  }
}

######################################## ALB
resource "aws_lb" "pub-alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.pub-alb-sg.id ]
  subnets            = aws_subnet.vpc_public.*.id
  enable_deletion_protection = false

  name = format(
    var.tags.Environment == null ? format("%s-%s-pub-alb", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-pub-alb", var.tags.Project,var.tags.Environment,var.tags.Owner)
  ) 
  tags = {
    Name = format(
      var.tags.Environment == null ? format("%s-%s-pub-alb", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-pub-alb", var.tags.Project,var.tags.Environment,var.tags.Owner)
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
  certificate_arn = data.aws_acm_certificate.kyeongsei-xyz.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub-alb-80.arn
  }
}

######################################## ALB Target group
resource "aws_lb_target_group" "pub-alb-80" {
  name = format(
    var.tags.Environment == null ? format("%s-%s-pub-alb-tg80", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-pub-alb-tg80", var.tags.Project,var.tags.Environment,var.tags.Owner)
  ) 
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  
  deregistration_delay = 30
  health_check {
    enabled = true
    healthy_threshold = 3 
    unhealthy_threshold = 3
    interval = 30
    path = "/common/login.do"
    port = "traffic-port"
  }  
}

######################################## ALB Target group Attach
resource "aws_lb_target_group_attachment" "pub-alb" {
  count = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.pub-alb-80.arn
  target_id        = aws_instance.web[count.index].id                    
  port             = 80
}




