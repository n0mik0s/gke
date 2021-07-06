variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "gcp project id"
}

variable "cluster_location" {
  type        = string
  default     = ""
  description = "cluster location"
}

variable "primary_ip_cidr_range" {
  type        = string
  default     = ""
  description = "network_primary_ip_cidr_range"
}

variable "master_ipv4_cidr_block" {
  type        = string
  default     = ""
  description = "network_master_ipv4_cidr_block"
}

variable "secondary_ip_range_svc" {
  type        = string
  default     = ""
  description = "network_secondary_ip_range_svc"
}

variable "secondary_ip_range_pods" {
  type        = string
  default     = ""
  description = "network_secondary_ip_range_pods"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster name"
}


variable "cluster_autoscaling" {
  type        = bool
  default     = false
  description = "cluster_autoscaling"
}

variable "cluster_type" {
  type        = string
  default     = ""
  description = "cluster_type"
}

variable "machine_type" {
  type        = string
  default     = ""
  description = "machine_type"
}

variable "default_max_pods_per_node" {
  type        = number
  default     = 0
  description = "cluster_default_max_pods_per_node"
}

variable "workload_identity_enabled" {
  type        = bool
  default     = false
  description = "cluster_workload_identity_enabled"
}

variable "istio_config" {
  type        = bool
  default     = false
  description = "istio_config"
}

variable "master_authorized_network" {
  type        = string
  default     = "0.0.0.0/0"
  description = "master_authorized_network"
}

variable "initial_node_count" {
  type        = number
  default     = 0
  description = "cluster_initial_node_count"
}

variable "cpu_min" {
  type        = number
  default     = 0
  description = "cluster_cpu_min"
}

variable "cpu_max" {
  type        = number
  default     = 0
  description = "cluster_cpu_max"
}

variable "memory_min" {
  type        = number
  default     = 0
  description = "cluster_memory_min"
}

variable "memory_max" {
  type        = number
  default     = 0
  description = "cluster_memory_max"
}

variable "min_node_count" {
  type        = number
  default     = 0
  description = "cluster_min_node_count"
}

variable "max_node_count" {
  type        = number
  default     = 0
  description = "cluster_max_node_count"
}

variable "network" {
  type        = string
  default     = ""
  description = "network id"
}

variable "cluster_region" {
  type        = string
  default     = ""
  description = "cluster region"
}

variable "cluster_node_locations" {
  type        = set(string)
  default     = []
  description = "cluster_node_locations"
}