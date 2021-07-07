variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "gcp project id"
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

variable "cluster_gke-1_name" {
  type        = string
  default     = ""
  description = "cluster_gke-1_name"
}

variable "cluster_gke-2_name" {
  type        = string
  default     = ""
  description = "cluster_gke-2_name"
}

variable "network" {
  type        = string
  default     = ""
  description = "network"
}

variable "instance_group_urls" {
  type        = set(any)
  default     = []
  description = "instance_group_urls"
}

variable "zones" {
  type        = set(string)
  default     = []
  description = "zones"
}