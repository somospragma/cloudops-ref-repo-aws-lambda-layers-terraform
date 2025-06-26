# Lambda Layers Sample - Variables

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

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
    error_message = "El entorno debe ser uno de: dev, qa, pdn."
  }
}

variable "layers_config" {
  description = "Map of Lambda layers to create for the sample"
  type = map(object({
    description = optional(string, "Lambda layer")
    type = string
    script_path = optional(string, "")
    source_dir  = optional(string, "")
    filename = optional(string, "")
    s3_bucket        = optional(string, "")
    s3_key           = optional(string, "")
    source_code_hash = optional(string, "")
    runtime      = optional(string, "python3.12")
    architecture = optional(string, "x86_64")
    additional_tags = optional(map(string), {})
  }))
  
  validation {
    condition = alltrue([
      for k, v in var.layers_config : contains(["compile", "file", "s3"], v.type)
    ])
    error_message = "Layer type must be one of: compile, file, s3"
  }
}