###########################################
#       Layer Resources                   #
###########################################

locals {
  # Generate consistent layer names following convention: {client}-{project}-{environment}-layer-{map_key}
  layer_names = {
    for k, v in var.layers_config : k => "${var.client}-${var.project}-${var.environment}-layer-${k}"
  }
}

# Create layer compilation resources (solo para type = "compile")
resource "null_resource" "layer_compilation" {
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "compile"
  }

  triggers = {
    script_hash = try(filesha256(each.value.script_path), "not-found")
  }

  provisioner "local-exec" {
    command = "bash ${each.value.script_path}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create archive files for compiled layers
data "archive_file" "compiled_layers" {
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "compile"
  }

  type        = "zip"
  source_dir  = each.value.source_dir
  output_path = each.value.filename

  depends_on = [
    null_resource.layer_compilation
  ]
}

# Create Lambda layers - type = "compile" 
resource "aws_lambda_layer_version" "compiled_layers" {
  provider = aws.project
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "compile"
  }

  layer_name               = local.layer_names[each.key]
  filename                 = data.archive_file.compiled_layers[each.key].output_path
  source_code_hash         = data.archive_file.compiled_layers[each.key].output_base64sha256
  compatible_runtimes      = [each.value.runtime]
  compatible_architectures = [each.value.architecture]
  description              = each.value.description

  depends_on = [
    data.archive_file.compiled_layers
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Create Lambda layers - type = "file"
resource "aws_lambda_layer_version" "file_layers" {
  provider = aws.project
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "file"
  }

  layer_name               = local.layer_names[each.key]
  filename                 = each.value.filename
  source_code_hash         = filebase64sha256(each.value.filename)
  compatible_runtimes      = [each.value.runtime]
  compatible_architectures = [each.value.architecture]
  description              = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}

# Create Lambda layers - type = "s3"
resource "aws_lambda_layer_version" "s3_layers" {
  provider = aws.project
  for_each = {
    for name, config in var.layers_config : name => config
    if config.type == "s3"
  }

  layer_name               = local.layer_names[each.key]
  s3_bucket                = each.value.s3_bucket
  s3_key                   = each.value.s3_key
  source_code_hash         = each.value.source_code_hash
  compatible_runtimes      = [each.value.runtime]
  compatible_architectures = [each.value.architecture]
  description              = each.value.description

  lifecycle {
    create_before_destroy = true
  }
}