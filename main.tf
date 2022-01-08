terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "local-state-tf"
    key    = "css/lite/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
  #access_key = var.aws_access_key
  #secret_key = var.aws_secret_key
  profile = "default"
  default_tags {
    tags = {
      Terraform   = true
      Product     = var.product
      Environment = var.environment
    }
  }
}