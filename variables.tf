variable "prefix" {
  type        = string
  default     = ""
  description = "Base prefix for naming for all resources"
}

variable "env" {
  type        = string
  default     = ""
  description = "Environment name"
}

variable "gcp_project_name" {
  type        = string
  default     = ""
  description = "GCP project name"
}

variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "GCP project ID"
}

variable "gcp_region" {
  type        = string
  default     = ""
  description = "GCP region"
}

variable "gcp_zone" {
  type        = string
  default     = ""
  description = "GCP zone"
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

variable "workload_identity_map" {
  type        = map(any)
  default     = {}
  description = "The list of objects that should be the inputs for workload_identity module"
}

variable "k8s_namespace_to_create" {
  type        = set(string)
  default     = []
  description = "k8s_namespace that should be created"
}