variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "gcp project id"
}

variable "gcp_regions" {
  type        = set(string)
  default     = []
  description = "Set of gcp regions for network module (Cloud Router and Cloud Nat configuration)"
}

variable "network_name" {
  type        = string
  default     = ""
  description = "network_name"
}
