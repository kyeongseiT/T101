#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
RZAZ=\$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone-id)
IID=\$(curl 169.254.169.254/latest/meta-data/instance-id)
LIP=\$(curl 169.254.169.254/latest/meta-data/local-ipv4)
echo "<h1>RegionAz(\$RZAZ) : Instance ID(\$IID) : Private IP(\$LIP) : Web Server Hello, T101 Study Kyeongsei</h1>" > /var/www/html/index.html            


sudo systemctl start httpd