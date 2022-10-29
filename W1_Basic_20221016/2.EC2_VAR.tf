#### EC2
########
variable "BASTION" {
  type        = string
  default     = "t3.micro"
}
variable "BASTION_VOL" {
  type        = string
  default     = "8"
}
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default      = 8090
}