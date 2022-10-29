## Parsing my IP addr
locals {
  my_ip_addrs = join("", [local.ifconfig_co_json.ip, "/32"])
}

data "http" "my_auto_ip_addr" {
  url = try("https://ifconfig.co/json", "")
  request_headers = {
    Accept = "application/json"
  }
}
locals {
  ifconfig_co_json = jsondecode(data.http.my_auto_ip_addr.body)
}

data "aws_ami" "ubuntu1804" {
 most_recent = true
 owners = ["099720109477"]

 filter {
   name   = "name"
   values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server*"]
 }
}
#ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20210415
#ami-0ba5cd124d7a79612

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

data "template_file" "web-userdata" {
  template = file("./userdata/web.sh")
}
