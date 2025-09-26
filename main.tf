###########################################
#       AWS Lambda Layer Resources       #
###########################################

# Create Lambda layers from ZIP files (local, builder, etc.)
resource "aws_lambda_layer_version" "zip_layers" {
  provider = aws.project
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "zip"
  }

  layer_name               = local.layer_names[each.key]
  filename                 = each.value.zip_path
  source_code_hash         = each.value.zip_hash
  compatible_runtimes      = [each.value.runtime]
  compatible_architectures = [each.value.architecture]
  description              = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}

# Create Lambda layers from S3 objects
resource "aws_lambda_layer_version" "s3_layers" {
  provider = aws.project
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "s3"
  }

  layer_name               = local.layer_names[each.key]
  s3_bucket                = each.value.s3_bucket
  s3_key                   = each.value.s3_key
  s3_object_version        = each.value.s3_object_version != "" ? each.value.s3_object_version : null
  source_code_hash         = each.value.source_code_hash
  compatible_runtimes      = [each.value.runtime]
  compatible_architectures = [each.value.architecture]
  description              = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}