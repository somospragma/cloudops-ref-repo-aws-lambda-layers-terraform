###########################################
######### Lambda Layers Module ###########
###########################################

variable "layers_config" {
  description = "Map of Lambda layers to create"
  type = map(object({
    # Identificación
    description = optional(string, "Lambda layer")
    
    # Tipo de fuente: compile, file, s3
    type = string
    
    # Para type = "compile"
    script_path = optional(string, "")
    source_dir  = optional(string, "")  # Directorio creado por el script
    
    # Para type = "file" o "compile"
    filename = optional(string, "")  # ZIP de salida/entrada
    
    # Para type = "s3"
    s3_bucket        = optional(string, "")
    s3_key           = optional(string, "")
    source_code_hash = optional(string, "")
    
    # Configuración AWS
    runtime      = optional(string, "python3.12")
    architecture = optional(string, "x86_64")
    
    # Etiquetas específicas del layer
    additional_tags = optional(map(string), {})
  }))
  default = {}
  
  validation {
    condition = alltrue([
      for k, v in var.layers_config : contains(["compile", "file", "s3"], v.type)
    ])
    error_message = "Layer type must be one of: compile, file, s3"
  }
}

###########################################
####### Sistema de Etiquetado ############
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
    condition     = contains(["dev", "qa", "pdn", "prod"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn, prod."
  }
}
