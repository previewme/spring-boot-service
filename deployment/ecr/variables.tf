variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "profile" {
  description = "The AWS profile to use"
  default     = "default"
  type        = string
}

variable "operations_assume_role" {
  description = "The role to assume for the operations account"
  type        = string
  sensitive   = true
}

variable "TFC_WORKSPACE_NAME" {
  type    = string
  default = "" # An error occurs when you are running TF backend other than Terraform Cloud
}