variable "aws_lb_app_version" {
  description = "AWS Load Balancer Controller Application version"
  type        = string
}

variable "openid_connect_provider_arn" {
  description = "AWS Openid Connect ARN"
  type        = string
}

variable "openid_connect_provider_url" {
  description = "AWS Openid Connect Url"
  type        = string
}

variable "environment" {
  description = "Stack environment"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}