###########################################
################ Outputs ##################
###########################################

output "layer_arns" {
  description = "Map of layer configuration keys to their AWS Lambda Layer ARNs"
  value = merge(
    {
      for k, v in aws_lambda_layer_version.zip_layers : k => v.arn
    },
    {
      for k, v in aws_lambda_layer_version.s3_layers : k => v.arn
    }
  )
}

output "layer_versions" {
  description = "Map of layer names to their versions"
  value = merge(
    {
      for k, v in aws_lambda_layer_version.zip_layers : k => v.version
    },
    {
      for k, v in aws_lambda_layer_version.s3_layers : k => v.version
    }
  )
}

output "layers_info" {
  description = "Complete information about all Lambda layers created"
  value = merge(
    {
      for k, v in aws_lambda_layer_version.zip_layers : k => {
        arn                = v.arn
        layer_arn         = v.layer_arn
        version           = v.version
        created_date      = v.created_date
        source_code_hash  = v.source_code_hash
        source_code_size  = v.source_code_size
        layer_name        = v.layer_name
        type              = "zip"
        source            = try(var.layers_config[k].zip_path, "")
      }
    },
    {
      for k, v in aws_lambda_layer_version.s3_layers : k => {
        arn                = v.arn
        layer_arn         = v.layer_arn
        version           = v.version
        created_date      = v.created_date
        source_code_hash  = v.source_code_hash
        source_code_size  = v.source_code_size
        layer_name        = v.layer_name
        type              = "s3"
        source            = "${try(var.layers_config[k].s3_bucket, "")}/${try(var.layers_config[k].s3_key, "")}"
      }
    }
  )
}