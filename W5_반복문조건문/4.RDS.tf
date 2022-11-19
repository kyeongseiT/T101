######################################## RDS

###################### Subnet group
resource "aws_db_subnet_group" "subnetgrp" {
    subnet_ids = aws_subnet.vpc_private_db.*.id

    name = lower(format(
        var.tags.Environment == null ? format("%s-%s-subnetgrp", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-subnetgrp", var.tags.Project,var.tags.Environment,var.tags.Owner)
    ) )
    tags = {
        Name = format(
            var.tags.Environment == null ? format("%s-%s-subnetgrp", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-subnetgrp", var.tags.Project,var.tags.Environment,var.tags.Owner)
        )
    }   
}

###################### Parameter group
resource "aws_db_parameter_group" "paramgrp" {
    family = var.paramgrp_famliy

    name = lower(format(
        var.tags.Environment == null ? format("%s-%s-paramgrp", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-paramgrp", var.tags.Project,var.tags.Environment,var.tags.Owner)
    ) )
    description = format(
        var.tags.Environment == null ? format("%s-%s-paramgrp", var.tags.Project,var.tags.Owner) : format("%s-%s-%s-paramgrp", var.tags.Project,var.tags.Environment,var.tags.Owner)
    )
    
    dynamic "parameter" {
        for_each = var.parameter
        content {
            name = parameter.value["name"]
            value = parameter.value["value"]
        }
    }   
}

###################### Option group
resource "aws_db_option_group" "optgrp" {  
    engine_name              = var.engine_name
    major_engine_version     = var.major_engine_version
    
    name = lower(format(
        var.tags.Environment == null ? format("%s-%s-%s-optgrp", var.tags.Project,var.tags.Owner,var.enginever) : format("%s-%s-%s-%s-optgrp", var.tags.Project,var.tags.Environment,var.tags.Owner,var.enginever)
    ) )    
    option_group_description = format(
        var.tags.Environment == null ? format("%s-%s-%s-optgrp", var.tags.Project,var.tags.Owner,var.enginever) : format("%s-%s-%s-%s-optgrp", var.tags.Project,var.tags.Environment,var.tags.Owner,var.enginever)
        )

    # option {
    #     option_name = "Timezone"
        
    #     option_settings {
    #         name  = "TIME_ZONE"
    #         value = "UTC"
    #     }
    # }
}

###################### RDS instance
# resource "aws_db_instance" "rds" {
#     allocated_storage = var.allocated_storage
#     # max_allocated_storage =
#     allow_major_version_upgrade = false
#     auto_minor_version_upgrade = false #default is true
#     availability_zone = "ap-northeast-2a"
#     backup_retention_period = "7"
#     # backup_window =
#     # character_set_name = # For Oracle MSSQL
#     copy_tags_to_snapshot = true # default is true
# #    db_name
#     db_subnet_group_name = aws_db_subnet_group.subnetgrp.name
#     delete_automated_backups = false # default is true
#     deletion_protection = false # default is false
#     engine = var.engine
#     engine_version = var.engine_version
#     # final_snapshot_identifier = false
#     identifier = lower(
#         format("%s-%s-%s-%s-rds",
#         var.title,var.environments,var.subtitle,var.engine)
#     )   
#     instance_class = var.instance_class
#     monitoring_interval = 0
#     multi_az = false
#     option_group_name = aws_db_option_group.optgrp.name
#     parameter_group_name = aws_db_parameter_group.paramgrp.name
#     password = var.dbpassword
#     performance_insights_enabled = false
#     storage_type = var.storage_type
#     tags = {
#         Name = format("%s-%s-%s-%s-rds",
#         var.title,var.environments,var.subtitle,var.engine)
#     }
#     # timezone = #for MSSQL
#     username = var.username
#     vpc_security_group_ids = [aws_security_group.rds-sg.id]
# }


###################### RDS sg
resource "aws_security_group" "rds-sg" { ######################
  ingress { 
    description = "From Bastion SG"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }  
  ingress { 
    description = "From WEB SG"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [ aws_security_group.web.id ]
  }    
  egress { #ALL
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.vpc.id

  name = format(
    var.tags.Environment == null ? format("%s-%s-%s-rds", var.tags.Project,var.tags.Owner,var.enginever) : format("%s-%s-%s-%s-rds", var.tags.Project,var.tags.Environment,var.tags.Owner,var.enginever)
  ) 
  description = format(
    var.tags.Environment == null ? format("%s-%s-%s-rds", var.tags.Project,var.tags.Owner,var.enginever) : format("%s-%s-%s-%s-rds", var.tags.Project,var.tags.Environment,var.tags.Owner,var.enginever)
  ) 
  tags = {
    Name = format(
        var.tags.Environment == null ? format("%s-%s-%s-rds", var.tags.Project,var.tags.Owner,var.enginever) : format("%s-%s-%s-%s-rds", var.tags.Project,var.tags.Environment,var.tags.Owner,var.enginever)
    )
  }
}
