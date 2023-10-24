# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "ProjectName" {
  description = "The name to use of all cluster resources { Recommended format: app-name_environment } e.g. terraform_staging"
  type = string
}

variable "environment" {
  description = "Environment in which application is supposed to be deployed e.g dev/staging/prod"
  type = string
}


variable "role_name" {
  description = "IAM role name ( This will be used in creating the IAM role)"
}

variable "additional_permissions" {
  description = "Additional permissions for IAM role"
  type = list(any)
  default = []
}

variable "resource_arn" {
  type = list(any)
  default = []
}
variable "servicename" {
  type = string
}
