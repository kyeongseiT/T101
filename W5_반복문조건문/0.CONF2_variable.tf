################################################## variable define
#Basic
variable "profile" {
  type    = string
}
variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "tags" { ## 프로젝트명-서비스명-(리소스명) 
  type = map
  default = {
    Project = "t101"
    Environment = null
    Owner = "kseit"
  }
}

variable "bastion_key_pair" {
  type    = string
}
variable "web_key_pair" {
  type    = string
}



################################################## VPC
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}
variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true ##default is false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Define whether to use ipv6"
  type        = string
  default     = "false"
}

################################################ EC2
######## BASTION
variable "bastion" {
  type        = string
  default     = "t3.micro"
}
variable "bastion_vol" {
  type        = string
  default     = "8"
}

######## web
variable "web" {
  type        = string
  default     = "t3.micro"
}
variable "web_vol" {
  type        = string
  default     = "8"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default      = 80
}

variable "disable_api_termination"{
  description = "If true, enables EC2 Instance Termination Protection."
  type = string
  default = "false"
}

######## db
variable "paramgrp_famliy"{
  description = "The family of the DB parameter group."
}
variable "enginever"{
  description = "The family of the DB parameter group."
}

variable "parameter"{
  description = "A list of DB parameters to apply. Note that parameters may differ from a family to an other"
  type = map(object({
    name = string
    value = string
  }))
  default = {}
}
##https://velog.io/@gentledev10/terraform-dynamic-blocks

variable "apply_method" {
  description = "immediate (default), or pending-reboot. Some engines can't apply some parameters without a reboot, and you will need to specify pending-reboot here."
  type = string
  default = "immediate"
}

#option grp
variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with."
}
variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with."
}

# rds instance
variable "allocated_storage" {
}
variable "allow_major_version_upgrade" {
}
variable "engine" {
}
variable "engine_version" {
}
variable "instance_class" {
}
variable "dbpassword" {
}
variable "storage_type" {
}
variable "username" {
}
