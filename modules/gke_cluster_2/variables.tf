variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "GCP project ID"
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

variable "k8s_namespace_to_create" {
  type        = set(string)
  default     = []
  description = "k8s_namespace that should be created"
}

variable "cluster_location" {
  type        = string
  default     = ""
  description = "GKE cluster location"
}

variable "cluster_type" {
  type        = string
  default     = ""
  description = "GKE cluster type: zonal|regional"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "GKE cluster name"
}


variable "gcp_and_k8s_sa_names" {
  description = "Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary."
  type        = string
}

variable "k8s_existing_sa_name" {
  description = "Name for the existing Kubernetes service account"
  type        = string
  default     = null
}

variable "k8s_namespace" {
  description = "Namespace for k8s service account"
  default     = "default"
  type        = string
}

variable "use_existing_k8s_sa" {
  description = "Use an existing kubernetes service account instead of creating one"
  default     = "false"
  type        = string
}

variable "annotate_k8s_sa" {
  description = "Annotate the kubernetes service account with 'iam.gke.io/gcp-service-account' annotation. Valid in cases when an existing SA is used."
  default     = true
  type        = bool
}

variable "automount_service_account_token" {
  description = "Enable automatic mounting of the service account token"
  default     = false
  type        = bool
}

variable "roles" {
  type        = list(string)
  default     = []
  description = "(optional) A list of roles to be added to the created Service account"
}

variable "endpoint" {
  type        = string
  default     = ""
  description = "K8s endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  default     = ""
  description = "K8s cluster_ca_certificate"
}