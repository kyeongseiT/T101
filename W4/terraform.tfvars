profile = "kyeongsei" # ~/.aws/credentials

region = "ap-northeast-2"
environments = "prd" #["prd", "qas", "dev"]

bastion_key_pair = "t101-prd-kseit-bastion-key"
web_key_pair = "t101-prd-kseit-web-key"

bastion = "t3.micro"
bastion_vol = "8"

web = "t3.micro"
web_vol = "8"

server_port = 80
disable_api_termination = "false" # true is protection

paramgrp_famliy = "mysql8.0"
enginever = "mysql80"

parameter = {
    param = {
        name = "time_zone"
        value = "Asia/Seoul"
    },
    param = {
        name = "character_set_client"
        value = "utf8"
    },
    param = {
        name = "character_set_connection"
        value = "utf8"
    },
    param = {
        name = "character_set_filesystem"
        value = "utf8"
    },
    param = {
        name = "character_set_results"
        value = "utf8"
    },
    param = {
        name = "character_set_server"
        value = "utf8"
    },
    param = {
        name = "activate_all_roles_on_login"
        value = "1"
    }    
}

engine_name = "mysql"
major_engine_version = "8.0"

allocated_storage = 30
allow_major_version_upgrade = "false"

engine = "mysql"
engine_version = "8.0.28"
instance_class = "db.r5.xlarge"
dbpassword = "adm123!!"
storage_type = "gp2"
username = "rdsadm"
