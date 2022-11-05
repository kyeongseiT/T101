# provider "aws" {
#   # version = "~> 3.20"
#   region = "ap-northeast-2"
#   shared_credentials_file = "~/.aws/credentials"
#   profile                 = var.profile
# }

terraform {
  backend "s3" {
    bucket = "kyeongsei-t101study-tfstate-week3-files"
    key    = "DB/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "terraform-locks-week3-files"
  }
}
data "terraform_remote_state" "vpcweb" {
  backend = "s3"
  config = {
    bucket = "kyeongsei-t101study-tfstate-week3-files"
    key    = "VPCWEB/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

output "address" {
  value       = aws_db_instance.myrds.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = aws_db_instance.myrds.port
  description = "The port the database is listening on"
}
