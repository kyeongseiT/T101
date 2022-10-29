# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = concat(aws_vpc.vpc.*.id, [""])[0]
# }


# output context 
############################
# AWS Environments
output "title" {
    value = var.title
    depends_on = [
        # Security group rule must be created before this IP address could
        # actually be used, otherwise the services will be unreachable.
        var.subtitle
    ]
}
output "subtitle" {
    value = var.subtitle
}
output "region" {
    value = var.region
}
output "account"{
    value = var.profile
}

############################
# vpc_id
output "vpc_id" {
    value = aws_vpc.vpc.id
}
output "public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The public IP address of the web server"
}