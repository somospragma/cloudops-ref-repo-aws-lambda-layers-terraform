###########################################
# Varibales Globales
###########################################

variable "client" {
  description = "Client name for resource naming and tagging"
  type        = string
}

variable "project" {
  description = "Project name for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name for resource naming and tagging"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "pdn"], var.environment)
    error_message = "Environment must be one of: dev, qa, pdn."
  }
}



###########################################
# Variable Lambda Layers
###########################################

variable "layers_config" {
  description = "Map of Lambda layers to create from ZIP files or S3"
  type = map(object({
    # Source Configuration - ZIP local (default) o S3
    type = optional(string, "zip")
    
    # Para ZIP local (desde builder, archivo local, etc.)
    zip_path = optional(string, "")
    zip_hash = optional(string, "")
    
    # Para type = "s3" (ZIP en S3)
    s3_bucket         = optional(string, "")
    s3_key            = optional(string, "")
    s3_object_version = optional(string, "")
    source_code_hash  = optional(string, "")
    
    # Configuración del layer
    description  = optional(string, "Lambda layer")
    runtime      = optional(string, "nodejs22.x")
    architecture = optional(string, "x86_64")
    
    # Etiquetas específicas del layer
    additional_tags = optional(map(string), {})
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for k, v in var.layers_config : contains(["zip", "s3"], v.type)
    ])
    error_message = "Layer type must be one of: zip (default), s3"
  }
  
  validation {
    condition = alltrue([
      for k, v in var.layers_config : (
        (v.type == "zip" && v.zip_path != "" && v.zip_hash != "") ||
        (v.type == "s3" && v.s3_bucket != "" && v.s3_key != "")
      )
    ])
    error_message = <<-EOT
      Each layer must have the appropriate fields for its type:
      - zip: zip_path and zip_hash required (from builder, local file, etc.)
      - s3: s3_bucket and s3_key required
    EOT
  }
}