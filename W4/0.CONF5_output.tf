# output context 

# AWS Environments
output "account"{
    value = var.profile
}
output "title" {
    value = var.title
}
output "subtitle" {
    value = var.subtitle
}
output "region" {
    value = var.region
}

# vpc_id
output "vpc_id" {
    value = aws_vpc.vpc.id
}