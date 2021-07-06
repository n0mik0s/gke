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
  description = "ping_devops_user"
}

variable "ping_devops_key_bd" {
  type        = string
  description = "ping_devops_key_bd"
}

variable "ping_devops_user_bd" {
  type        = string
  description = "ping_devops_user_bd"
}

variable "helm_namespace" {
  type        = string
  default     = ""
  description = "helm_namespace"
}

variable "lb_exposed_port" {
  type        = number
  default     = 443
  description = "lb_exposed_port"
}

variable "lb_neg_name" {
  type        = string
  default     = ""
  description = "lb_neg_name"
}