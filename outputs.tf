###########################################
################ Outputs ##################
###########################################

###########################################
############ Lambda Layers ################
###########################################

output "layer_arns" {
  description = "Map of layer configuration keys to their AWS Lambda Layer ARNs for use in Lambda functions"
  value = merge(
    {
      for k, v in aws_lambda_layer_version.compiled_layers : k => v.arn
    },
    {
      for k, v in aws_lambda_layer_version.file_layers : k => v.arn
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
      for k, v in aws_lambda_layer_version.compiled_layers : k => v.version
    },
    {
      for k, v in aws_lambda_layer_version.file_layers : k => v.version
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
      for k, v in aws_lambda_layer_version.compiled_layers : k => {
        arn                = v.arn
        layer_arn         = v.layer_arn
        version           = v.version
        created_date      = v.created_date
        source_code_hash  = v.source_code_hash
        source_code_size  = v.source_code_size
        layer_name        = v.layer_name
        type              = "compile"
      }
    },
    {
      for k, v in aws_lambda_layer_version.file_layers : k => {
        arn                = v.arn
        layer_arn         = v.layer_arn
        version           = v.version
        created_date      = v.created_date
        source_code_hash  = v.source_code_hash
        source_code_size  = v.source_code_size
        layer_name        = v.layer_name
        type              = "file"
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
      }
    }
  )
}

###########################################
########## Summary Information ############
###########################################

output "summary" {
  description = "Summary of layers created by this module"
  value = {
    total_layers = (
      length(aws_lambda_layer_version.compiled_layers) +
      length(aws_lambda_layer_version.file_layers) +
      length(aws_lambda_layer_version.s3_layers)
    )
    layer_names = concat(
      keys(aws_lambda_layer_version.compiled_layers),
      keys(aws_lambda_layer_version.file_layers),
      keys(aws_lambda_layer_version.s3_layers)
    )
    compiled_layers = keys(aws_lambda_layer_version.compiled_layers)
    file_layers     = keys(aws_lambda_layer_version.file_layers)
    s3_layers       = keys(aws_lambda_layer_version.s3_layers)
  }
}