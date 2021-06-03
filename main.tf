module "gke_cluster_1" {
  source = "./modules/gke_cluster_1"

  nodes_ip_cidr_range = var.ping_cluster_1.nodes_ip_cidr_range
  pods_ip_cidr_range = var.ping_cluster_1.pods_ip_cidr_range
  svcs_ip_cidr_range = var.ping_cluster_1.svcs_ip_cidr_range

  cluster_location = var.ping_cluster_1.cluster_location
  cluster_region = var.ping_cluster_1.cluster_region
  cluster_type = var.ping_cluster_1.cluster_type
  cluster_name = var.ping_cluster_1.cluster_name
  cluster_autoscaling = tobool(var.ping_cluster_1.cluster_autoscaling)
  cpu_min = tonumber(var.ping_cluster_1.cpu_min)
  cpu_max = tonumber(var.ping_cluster_1.cpu_max)
  memory_min = tonumber(var.ping_cluster_1.memory_min)
  memory_max = tonumber(var.ping_cluster_1.memory_max)

  gcp_project_id = var.ping_cluster_1.gcp_project_id

  workload_identity_enabled = tobool(var.ping_cluster_1.workload_identity_enabled)
  initial_node_count = var.ping_cluster_1.initial_node_count

  k8s_namespace_to_create = split(",", var.ping_cluster_1.k8s_namespace_to_create)

  gcp_and_k8s_sa_names = var.ping_cluster_1.gcp_and_k8s_sa_names
  k8s_namespace = var.ping_cluster_1.k8s_namespace
  roles = split(",", var.ping_cluster_1.roles)
}

module "gke_cluster_2" {
  source = "./modules/gke_cluster_2"

  nodes_ip_cidr_range = var.ping_cluster_2.nodes_ip_cidr_range
  pods_ip_cidr_range = var.ping_cluster_2.pods_ip_cidr_range
  svcs_ip_cidr_range = var.ping_cluster_2.svcs_ip_cidr_range

  cluster_location = var.ping_cluster_2.cluster_location
  cluster_region = var.ping_cluster_2.cluster_region
  cluster_type = var.ping_cluster_2.cluster_type
  cluster_name = var.ping_cluster_2.cluster_name
  cluster_autoscaling = tobool(var.ping_cluster_2.cluster_autoscaling)

  gcp_project_id = var.ping_cluster_2.gcp_project_id

  workload_identity_enabled = tobool(var.ping_cluster_2.workload_identity_enabled)
  initial_node_count = var.ping_cluster_2.initial_node_count

  k8s_namespace_to_create = split(",", var.ping_cluster_2.k8s_namespace_to_create)

  gcp_and_k8s_sa_names = var.ping_cluster_2.gcp_and_k8s_sa_names
  k8s_namespace = var.ping_cluster_2.k8s_namespace
  roles = split(",", var.ping_cluster_2.roles)
}

module "peering" {
  source = "./modules/network-peering"

  prefix        = "telus"
  export_local_custom_routes = true
  export_peer_custom_routes = true
  export_peer_subnet_routes_with_public_ip = true
  local_network = module.gke_cluster_1.network
  peer_network  = module.gke_cluster_2.network
}