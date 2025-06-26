# Lambda Layers Module - Sample Configuration

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      environment = var.environment
      project     = var.project
      owner       = "cloudops"
      client      = var.client
      area        = "infrastructure"
      provisioned = "terraform"
      datatype    = "operational"
    }
  }
}

# Lambda Layers Module
module "sample_lambda_layers" {
  source = "../"
  
  # Sistema de etiquetado
  client      = var.client
  project     = var.project
  environment = var.environment
  
  # Configuración de layers de ejemplo
  layers_config = var.layers_config
}