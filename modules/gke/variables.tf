variable "gcp_region" {
  type        = string
  default     = ""
  description = "The region that GKE would be placed to"
}

variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "GCP project ID"
}

variable "network" {
  type        = string
  default     = ""
  description = "VPC network name created for K8s"
}

variable "subnetwork" {
  type        = string
  default     = ""
  description = "VPC subnetwork name created within VPC network for K8s"
}

variable "cluster_secondary_range_name" {
  type        = string
  default     = ""
  description = "Cluster secondary range name"
}

variable "services_secondary_range_name" {
  type        = string
  default     = ""
  description = "Services secondary range name"
}

variable "machine_type" {
  type        = string
  default     = ""
  description = "Type of VMs that runs as K8S nodes"
}

variable "initial_node_count" {
  type        = string
  default     = ""
  description = "GKE node pool: initial node count"
}

variable "workload_identity_enabled" {
  type        = bool
  default     = false
  description = "Do we enable or not GKE workload identity"
}

variable "k8s_namespace_to_create" {
  type        = set(string)
  default     = []
  description = "k8s_namespace that should be created"
}
