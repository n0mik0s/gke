module "gke_cluster_1" {
  source = "./modules/gke_cluster_1"

  nodes_ip_cidr_range = var.ping_cluster_1.nodes_ip_cidr_range
  pods_ip_cidr_range = var.ping_cluster_1.pods_ip_cidr_range
  svcs_ip_cidr_range = var.ping_cluster_1.svcs_ip_cidr_range

  cluster_location = var.ping_cluster_1.cluster_location
  cluster_type = var.ping_cluster_1.cluster_type
  cluster_name = var.ping_cluster_1.cluster_name

  gcp_project_id = var.ping_cluster_1.gcp_project_id

  workload_identity_enabled = var.ping_cluster_1.workload_identity_enabled
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
  cluster_type = var.ping_cluster_2.cluster_type
  cluster_name = var.ping_cluster_2.cluster_name

  gcp_project_id = var.ping_cluster_2.gcp_project_id

  workload_identity_enabled = var.ping_cluster_2.workload_identity_enabled
  initial_node_count = var.ping_cluster_2.initial_node_count

  k8s_namespace_to_create = split(",", var.ping_cluster_2.k8s_namespace_to_create)

  gcp_and_k8s_sa_names = var.ping_cluster_2.gcp_and_k8s_sa_names
  k8s_namespace = var.ping_cluster_2.k8s_namespace
  roles = split(",", var.ping_cluster_2.roles)
}

module "peering" {
  source = "./modules/network-peering"

  prefix        = "telus"
  local_network = module.gke_cluster_1.network
  peer_network  = module.gke_cluster_2.network
}