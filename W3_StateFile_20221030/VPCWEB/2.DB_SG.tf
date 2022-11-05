
resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.vpc.id

  ingress { 
    description = "From web s3"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups    = [aws_security_group.was-sg.id]
  }   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  name = format(
      "%s-%s-db-SG",
      var.title,var.subtitle
    )
  description = format(
      "%s-%s-db-SG",
      var.title,var.subtitle
    )
  tags = {
    Name = format(
      "%s-%s-db-SG",
      var.title,var.subtitle
    )
  }
}

