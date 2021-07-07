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