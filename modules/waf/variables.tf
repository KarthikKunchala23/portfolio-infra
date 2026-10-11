variable "project_name" {
  type        = string
  description = "Project name used for WAF resources"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "rate_limit" {
  type        = number
  description = "Maximum requests per IP during the WAF evaluation window"
  default     = 300
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to WAF resources"
  default     = {}
}