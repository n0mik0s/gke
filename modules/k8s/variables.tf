variable "namespaces" {
  type        = set(string)
  default     = []
  description = "namespaces"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster_name"
}

variable "helm_namespace" {
  type        = string
  default     = ""
  description = "helm_namespace"
}

variable "lb_exposed_port" {
  type        = number
  default     = null
  description = "The port should be exposed"
}

variable "lb_neg_name" {
  type        = string
  default     = ""
  description = "lb_neg_name"
}

variable "svc_instance" {
  type        = string
  default     = ""
  description = "svc_instance"
}

variable "svc_enabled" {
  type        = bool
  default     = false
  description = "svc_enabled"
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