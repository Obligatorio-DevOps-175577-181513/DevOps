variable "environment" {
  description = "The environment to deploy to (dev, stg, prod)"
  type        = string
}

variable "service_names" {
  description = "List of service names"
  type        = list(string)
}

variable "principal_arn" {
  description = "ARN of the principal role"
  type        = string
}