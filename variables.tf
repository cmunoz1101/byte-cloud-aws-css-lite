variable "product" {
  type    = string
  default = "consensus"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

// **************************************************************
// *                           VPC                              *
// **************************************************************
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" { // si len(az)=2 y len(private_subnets)=4 => private_subnets[0] in az[0], private_subnets[1] in az[1], private_subnets[2] in az[0], private_subnets[3] in az[1]
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
}

variable "database_subnets" {
  type    = list(string)
  default = ["10.0.105.0/24", "10.0.106.0/24"]
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

// **************************************************************
// *                           RDS                              *
// **************************************************************
variable "rds_master_username" {
  type    = string
  default = "root"
}

variable "rds_master_password" {
  type    = string
  default = "admin123"
}

variable "rds_cluster_parameters" {
  type = list(object({
    apply_method = string,
    name         = string,
    value        = any
  }))
  default = [
    {
      apply_method = "pending-reboot",
      name         = "lower_case_table_names",
      value        = 1
    },
    {
      apply_method = "pending-reboot",
      name         = "explicit_defaults_for_timestamp",
      value        = 1
    },
    {
      apply_method = "pending-reboot",
      name         = "max_connections",
      value        = 1000
    },
    {
      apply_method = "pending-reboot",
      name         = "max_allowed_packet",
      value        = 104857600
    },
    {
      apply_method = "pending-reboot",
      name         = "bulk_insert_buffer_size",
      value        = 104857600
    }
  ]
}

variable "rds_db_parameters" {
  type = list(object({
    apply_method = string,
    name         = string,
    value        = any
  }))
  default = []
}

variable "rds_scaling_configuration" {
  type = object({
    auto_pause               = bool,
    min_capacity             = number,
    max_capacity             = number,
    seconds_until_auto_pause = number,
    timeout_action           = string
  })
  default = { //Mapa de atributos anidados con propiedades de escala. Solo es válido cuando engine_mode se establece en serverless
    auto_pause               = true,
    min_capacity             = 2,
    max_capacity             = 2,
    seconds_until_auto_pause = 300,
    timeout_action           = "ForceApplyCapacityChange"
  }
}