provider "aws" {
  # version = "~> 3.20"
  region = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.profile
}

##################################################
variable "title" {
  type        = string
  default     = "T101"
}
variable "subtitle" {
  type        = string
  default     = "kyeongsei"
}
variable "region" {
  type    = string
  default = "ap-northeast-2"
}
variable "profile" {
  type    = string
  default = "kyeongsei" ##
}

variable "key_pair" {
  type    = string
  default = "kyeongseikey"
}

##################################################
variable "vpc_cidr" {
  type        = string
  default     = "10.224.0.0/16"
}

##################################################

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "assign_generated_ipv6_cidr_block" {
  description = "Define whether to use ipv6"
  type        = string
  default     = "false"
}
