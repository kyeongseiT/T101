######################################## NLB

resource "aws_lb" "pub-nlb" {
  name = format(
      "%s-%s-pub-nlb",
      var.title,var.subtitle
  )  
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.vpc_public.*.id
  enable_deletion_protection = true

  tags = {
    Name = format(
      "%s-%s-pub-nlb",
      var.title,var.subtitle
    )
  }  
}

######################################## LB listner
resource "aws_lb_listener" "pub-nlb-443" {
  load_balancer_arn = aws_lb.pub-nlb.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.kyeongsei-xyz.id

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub-nlb-80.arn
  }
}

######################################## ALB TG
resource "aws_lb_target_group" "pub-nlb-80" {
  name = format(
      "%s-%s-pub-nlb-tg80",
      var.title,var.subtitle
    )  
  port     = "80"
  protocol = "TCP"
  vpc_id   = aws_vpc.vpc.id
}

######################################## LB TG Attach
# resource "aws_lb_target_group_attachment" "pub-alb" {
#   target_group_arn = aws_lb_target_group.pub-alb-80.arn
#   target_id        = aws_instance.was.id                    
#   port             = 80
# }




