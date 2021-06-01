variable "gcp_and_k8s_sa_names" {
  description = "Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary."
  type        = string
}

variable "cluster_name" {
  description = "Cluster name. Required if using existing KSA."
  type        = string
  default     = ""
}

variable "gcp_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster). Required if using existing KSA."
  type        = string
  default     = ""
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

variable "gcp_project_id" {
  description = "GCP project ID"
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

