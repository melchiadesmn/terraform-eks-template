variable "prefix_name" {
  description = "Prefix for resources"
  type        = string
}

variable "resources" {
  description = "Resources IDs for backup"
  type        = list(string)
}

variable "environment" {
  description = "Stack environment"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}