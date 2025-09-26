locals {
  # Generate consistent layer names following convention: {client}-{project}-{environment}-layer-{map_key}
  layer_names = {
    for k, v in var.layers_config : k => "${var.client}-${var.project}-${var.environment}-layer-${k}"
  }
}