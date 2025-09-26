# Lambda Layers Module
module "sample_lambda_layers" {
  source = "../"
  
  providers = {
    aws.project = aws
  }
  
  # Sistema de etiquetado
  client      = var.client
  project     = var.project
  environment = var.environment
  
  # Configuración de layers de ejemplo
  layers_config = var.layers_config
}