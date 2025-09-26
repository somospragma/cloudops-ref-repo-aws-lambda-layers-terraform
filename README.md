# Módulo Terraform: lambda-layers

## Descripción

Este módulo gestiona la creación y configuración de AWS Lambda Layers reutilizables. Los layers permiten compartir código, bibliotecas y dependencias entre múltiples funciones Lambda, mejorando la eficiencia y reduciendo el tamaño de los paquetes de despliegue.

Para más detalles sobre los cambios y versiones, consulte el [CHANGELOG.md](./CHANGELOG.md).

## ✅ Características

- ✅ Soporte para múltiples tipos de fuente (zip, s3)
- ✅ Gestión de archivos ZIP locales pre-existentes
- ✅ Integración con S3 para pipelines de CI/CD
- ✅ Sistema de etiquetado consistente
- ✅ Validaciones de entrada robustas
- ✅ Configuración flexible por layer
- ✅ Compatibilidad con múltiples runtimes y arquitecturas
- ✅ Separación de responsabilidades (build vs deploy)

## Estructura del Módulo

```
lambda-layers/
├── README.md           # Este archivo
├── CHANGELOG.md        # Historial de cambios
├── main.tf            # Recursos principales
├── variables.tf       # Variables de entrada
├── outputs.tf         # Valores de salida
└── providers.tf       # Configuración de proveedores
```

## Implementación y Configuración

### Requisitos Técnicos

- **Terraform**: >= 1.0
- **Provider AWS**: >= 4.31.0

### Provider Configuration

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.31.0"
      configuration_aliases = [aws.project]
    }
  }
}
```

### Convenciones de Nomenclatura

Los resources creados siguen la convención:
```
{client}-{project}-{environment}-layer-{name}
```

Ejemplo: `pragma-genai-dev-layer-aws-sdk`

### Estrategia de Etiquetado

El módulo aplica tags automáticamente siguiendo la estrategia corporativa:
- **Name**: Nombre del layer generado
- **Environment**: Entorno de despliegue
- **Client**: Cliente propietario
- **Project**: Proyecto asociado

### Recursos Gestionados

- `aws_lambda_layer_version`: Versiones de layers de Lambda desde ZIP local
- `aws_lambda_layer_version`: Versiones de layers de Lambda desde S3

### Parámetros de Entrada

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_layers_config"></a> [layers_config](#input_layers_config) | Mapa de configuración de layers a crear | `map(object)` | `{}` | yes |
| <a name="input_client"></a> [client](#input_client) | Nombre del cliente para etiquetado | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input_project) | Nombre del proyecto para etiquetado | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input_environment) | Entorno de despliegue (dev, qa, pdn) | `string` | n/a | yes |

### Estructura de Configuración

```hcl
layers_config = {
  layer-name = {
    type        = "zip"  # zip, s3
    description = "Descripción del layer"
    runtime     = "nodejs22.x"
    
    # Para type = "zip" (archivo local)
    zip_path = "path/to/layer.zip"
    zip_hash = "sha256-hash"
    
    # Para type = "s3"
    s3_bucket         = "bucket-name"
    s3_key            = "path/to/layer.zip"
    s3_object_version = "version-id"  # opcional
    source_code_hash  = "sha256-hash"
    
    # Configuración adicional
    architecture    = "x86_64"
    additional_tags = {
      Purpose = "shared-libraries"
    }
  }
}
```

### Valores de Salida

| Name | Description |
|------|-------------|
| <a name="output_layer_arns"></a> [layer_arns](#output_layer_arns) | ARNs de todos los layers creados |
| <a name="output_layer_versions"></a> [layer_versions](#output_layer_versions) | Versiones de todos los layers creados |

### Ejemplos de Uso

#### Ejemplo 1: Layer desde ZIP Local

```hcl
module "lambda_layers" {
  source = "./modules/lambda-layers"
  
  providers = {
    aws.project = aws
  }
  
  client      = "pragma"
  project     = "genai"
  environment = "dev"
  
  layers_config = {
    requests-layer = {
      type        = "zip"
      zip_path    = "layers/requests-layer.zip"
      zip_hash    = filebase64sha256("layers/requests-layer.zip")
      description = "Python requests library layer"
      runtime     = "python3.12"
    }
  }
}
```

#### Ejemplo 2: Layer desde S3

```hcl
module "lambda_layers" {
  source = "./modules/lambda-layers"
  
  providers = {
    aws.project = aws
  }
  
  client      = "pragma"
  project     = "genai"
  environment = "dev"
  
  layers_config = {
    utils-layer = {
      type             = "s3"
      s3_bucket        = "my-lambda-artifacts"
      s3_key           = "layers/utils-layer-v1.0.0.zip"
      source_code_hash = "sha256-abcdef123456..."
      description      = "Utilities layer from S3"
      runtime          = "nodejs22.x"
    }
  }
}
```

## Escenarios de Uso Comunes

### 1. Desarrollo Local
- Uso de archivos ZIP construidos externamente
- Separación clara entre build y deploy
- Validación local de layers

### 2. Pipeline CI/CD
- Uso de layers pre-compilados desde S3
- Gestión de versiones con source_code_hash
- Despliegue automatizado

### 3. Entornos Mixtos
- Combinación de layers locales y desde S3
- Reutilización entre diferentes proyectos
- Optimización de tiempos de despliegue

## Consideraciones Operativas

### Performance
- Despliegue rápido usando artefactos pre-construidos
- Reutilización automática de layers existentes
- Optimización de tiempos de despliegue

### Escalabilidad
- Soporte para múltiples layers simultáneos
- Configuración flexible por layer
- Integración con sistemas de CI/CD

### Mantenimiento
- Separación clara de responsabilidades
- Gestión de versiones con hashes
- Trazabilidad completa de artefactos

## Seguridad y Cumplimiento

### Controles de Seguridad
- Validación de tipos de entrada
- Verificación de integridad con hashes
- Etiquetado para governance

### Cumplimiento
- Nomenclatura estándar corporativa
- Trazabilidad completa de recursos
- Auditoría de cambios

## Observaciones

- **Artefactos**: Los archivos ZIP deben ser construidos externamente antes del despliegue
- **Tamaño**: Los layers están limitados a 250MB (sin comprimir)
- **Compatibilidad**: Verificar compatibilidad de runtime entre layer y función
- **Versionado**: AWS crea automáticamente nuevas versiones para cada cambio
- **Separación**: El módulo se enfoca únicamente en el despliegue, no en la construcción