variable "ping_cluster_1" {
  type        = map(any)
  default     = {}
  description = "The map of objects that should be the inputs for workload_identity module"
}

variable "ping_cluster_2" {
  type        = map(any)
  default     = {}
  description = "The map of objects that should be the inputs for gke module"
}