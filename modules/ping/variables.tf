variable "helm_repository" {
  type        = string
  default     = ""
  description = "Helm repository"
}

variable "helm_chart" {
  type        = string
  default     = ""
  description = "Helm chart"
}

variable "ping_devops_user" {
  type        = string
  default     = ""
  description = "ping_devops_user"
}

variable "ping_devops_key_bd" {
  type        = string
  default     = ""
  description = "ping_devops_key_bd"
}

variable "ping_devops_user_bd" {
  type        = string
  default     = ""
  description = "ping_devops_user_bd"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "namespace"
}
