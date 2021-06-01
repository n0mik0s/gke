variable "region" {
  type        = string
  default     = ""
  description = "The region that GKE would be placed to"
}

variable "nodes_ip_cidr_range" {
  type        = string
  default     = ""
  description = "Nodes ip cidr range"
}

variable "pods_ip_cidr_range" {
  type        = string
  default     = ""
  description = "Pods ip cidr range"
}

variable "svcs_ip_cidr_range" {
  type        = string
  default     = ""
  description = "Services ip cidr range"
}