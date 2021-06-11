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

variable "k8s_namespaces" {
  type        = set(string)
  default     = []
  description = "k8s_namespace that should be created"
}

variable "cluster_location" {
  type        = string
  default     = ""
  description = "GKE cluster location"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "GKE cluster name"
}

variable "cluster_autoscaling" {
  type        = bool
  default     = false
  description = "Whether we need or not cluster_autoscaling feature"
}

variable "cpu_min" {
  type        = number
  default     = 0
  description = "cpu_min"
}

variable "cpu_max" {
  type        = number
  default     = 0
  description = "cpu_max"
}

variable "memory_min" {
  type        = number
  default     = 0
  description = "memory_min"
}

variable "memory_max" {
  type        = number
  default     = 0
  description = "memory_max"
}

variable "max_node_count" {
  type        = number
  default     = 1
  description = "Nodes config autoscaling: max node count"
}

variable "min_node_count" {
  type        = number
  default     = 0
  description = "Nodes config autoscaling: min node count"
}

variable "default_max_pods_per_node" {
  type        = number
  default     = 0
  description = "Default: max pods per node"
}

variable "primary_ip_cidr_range" {
  type        = string
  default     = ""
  description = "Primary ip cidr range, used for nodes"
}

variable "secondary_ip_range" {
  type        = set(map(string))
  default     = []
  description = "Secondary ip cidr range, used for services and pods"
}

variable "network" {
  type        = string
  default     = ""
  description = "Network id"
}

variable "istio_config" {
  type        = bool
  default     = false
  description = "Whether enable or not istio_config for the cluster"
}

variable "master_ipv4_cidr_block" {
  type        = string
  default     = ""
  description = "The IP range in CIDR notation to use for the hosted master network. This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP"
}

variable "bastion_cidr_block" {
  type        = string
  default     = ""
  description = "Bastion cidr block"
}

variable "master_authorized_network" {
  type        = string
  default     = ""
  description = "master_authorized_network"
}
