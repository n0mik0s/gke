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

variable "helm_namespace" {
  type        = string
  default     = ""
  description = "helm_namespace"
}