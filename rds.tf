module "aurora_mysql" {

  depends_on = [module.rds_sg]

  source = "terraform-aws-modules/rds-aurora/aws"

  name              = format("%s-%s-rds-aurora-mysql-serverless", var.product, var.environment)
  engine            = "aurora-mysql"
  engine_mode       = "serverless" // El modo de motor de base de datos. Los valores válidos: global, multimaster, parallelquery, provisioned, serverless. Predeterminado:provisioned
  storage_encrypted = true         // Almacenamiento encriptado. Especifica si el clúster de base de datos está cifrado. El valor predeterminado es true.

  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.database_subnets
  create_security_group  = false
  vpc_security_group_ids = [module.rds_sg.security_group_id]
  allowed_cidr_blocks    = concat(module.vpc.public_subnets_cidr_blocks, module.vpc.private_subnets_cidr_blocks)

  create_random_password = false
  master_username        = var.rds_master_username
  master_password        = var.rds_master_password

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = var.environment == "prod" ? false : true

  db_parameter_group_name         = aws_db_parameter_group.db_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameter_group.id
  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = var.rds_scaling_configuration

  cluster_tags = {
    Name = format("%s-%s-rds-aurora-mysql-serverless", var.product, var.environment)
  }

}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {

  name        = format("%s-%s-pg-aurora-mysql-cluster", var.product, var.environment)
  family      = "aurora-mysql5.7"
  description = format("%s-%s-pg-aurora-mysql-cluster", var.product, var.environment)
  dynamic "parameter" {
    for_each = { for index, value in var.rds_cluster_parameters : index => value }
    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = {
    Name = format("%s-%s-pg-aurora-mysql-cluster", var.product, var.environment)
  }

}

resource "aws_db_parameter_group" "db_parameter_group" {

  name        = format("%s-%s-pg-aurora-db-mysql", var.product, var.environment)
  family      = "aurora-mysql5.7"
  description = format("%s-%s-pg-aurora-db-mysql", var.product, var.environment)
  dynamic "parameter" {
    for_each = { for index, value in var.rds_db_parameters : index => value }
    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = {
    Name = format("%s-%s-pg-aurora-db-mysql", var.product, var.environment)
  }

}