provider "aws" {
  region = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.profile

  default_tags {
    tags = {
      T101 = "kyeongsei"
    }
  }  
}