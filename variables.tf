variable "cluster" {
  type = object({
    gcp_project_id            = string
    gcp_region                = string
    cluster_type              = string
    cluster_name              = string
    cluster_location          = string
    cluster_autoscaling       = bool
    cpu_min                   = number
    cpu_max                   = number
    memory_min                = number
    memory_max                = number
    min_node_count            = number
    max_node_count            = number
    primary_ip_cidr_range     = string
    master_ipv4_cidr_block    = string
    secondary_ip_range        = set(map(string))
    machine_type              = string
    initial_node_count        = number
    default_max_pods_per_node = number
    workload_identity_enabled = bool
    k8s_namespaces            = list(string)
    istio_config              = bool
    master_authorized_network = string
  })
  default = {
    gcp_project_id            = ""
    gcp_region                = ""
    cluster_type              = ""
    cluster_name              = ""
    cluster_location          = ""
    cluster_autoscaling       = false
    cpu_min                   = 0
    cpu_max                   = 0
    memory_min                = 0
    memory_max                = 0
    min_node_count            = 0
    max_node_count            = 0
    primary_ip_cidr_range     = ""
    master_ipv4_cidr_block    = ""
    secondary_ip_range        = [{}]
    machine_type              = ""
    initial_node_count        = 0
    default_max_pods_per_node = 0
    workload_identity_enabled = false
    k8s_namespaces            = []
    istio_config              = false
    master_authorized_network = ""
  }
  description = "The object that should be the input for all existing modules"
}

variable "workload_identity_list" {
  type = map(object({
    gcp_and_k8s_sa_names = string
    k8s_namespace        = string
    roles                = list(string)
  }))
  default     = {}
  description = "The list of objects that should be the inputs for workload_identity module"
}

variable "bastion" {
  type = object({
    enabled               = bool
    primary_ip_cidr_range = string
    gcp_zone              = string
    machine_type          = string
  })
  default = {
    enabled               = false
    primary_ip_cidr_range = ""
    gcp_zone              = ""
    machine_type          = ""
  }
  description = "The list of items for bastion host configuration"
}

variable "ping" {
  type = object({
    enabled             = bool
    helm_repository     = string
    helm_chart          = string
    ping_devops_user    = string
    ping_devops_key_bd  = string
    ping_devops_user_bd = string
    namespace           = string
  })
  default = {
    enabled             = false
    helm_repository     = ""
    helm_chart          = ""
    ping_devops_user    = ""
    ping_devops_key_bd  = ""
    ping_devops_user_bd = ""
    namespace           = ""
  }
  description = "The list of items for helm configuration"
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "Backend bucket_name"
}
