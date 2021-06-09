variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "GCP project ID"
}

variable "network_name" {
  type        = string
  default     = ""
  description = "Network name"
}

variable "ssh_destination_ranges" {
  type        = set(string)
  default     = []
  description = "ssh_destination_ranges"
}

variable "gcp_region" {
  type        = string
  default     = ""
  description = "gcp_region"
}
