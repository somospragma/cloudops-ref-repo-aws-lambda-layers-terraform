# Lambda Layers Sample - Outputs

output "layer_arns" {
  description = "ARNs of the Lambda layers created in this sample"
  value       = module.sample_lambda_layers.layer_arns
}

output "layer_versions" {
  description = "Versions of the Lambda layers created in this sample"
  value       = module.sample_lambda_layers.layer_versions
}

output "layers_info" {
  description = "Complete information about all Lambda layers created in this sample"
  value       = module.sample_lambda_layers.layers_info
}

output "summary" {
  description = "Summary of resources created in this sample"
  value       = module.sample_lambda_layers.summary
}