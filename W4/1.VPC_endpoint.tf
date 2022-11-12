resource "aws_vpc_endpoint" "s3_endpoint" {
  service_name = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway" #default
  vpc_id       = aws_vpc.vpc.id
  route_table_ids = [aws_route_table.vpc_private_web.id]
  
   tags = {
    Name = format(
      "%s-%s-%s-s3-vpcep",
      var.title,var.environments,var.subtitle
    )
   }
}
