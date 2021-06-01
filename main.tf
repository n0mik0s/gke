data "google_client_config" "default" {}

module "network" {
  source = "./modules/network"

  region = var.gcp_region
  nodes_ip_cidr_range = var.nodes_ip_cidr_range
  pods_ip_cidr_range = var.pods_ip_cidr_range
  svcs_ip_cidr_range = var.svcs_ip_cidr_range
}

module "gke" {
  source = "./modules/gke"

  gcp_region = var.gcp_region
  gcp_project_id = var.gcp_project_id

  workload_identity_enabled = var.workload_identity_enabled
  initial_node_count = var.initial_node_count
  
  network = module.network.network
  subnetwork = module.network.subnetwork
  cluster_secondary_range_name  = module.network.cluster_secondary_range_name
  services_secondary_range_name = module.network.services_secondary_range_name

  k8s_namespace_to_create = var.k8s_namespace_to_create
}

module "workload_identity" {
  for_each = var.workload_identity_map

  source = "./modules/workload-identity"

  endpoint = module.gke.endpoint
  cluster_ca_certificate = module.gke.cluster_ca_certificate
  
  gcp_and_k8s_sa_names = each.value.gcp_and_k8s_sa_names
  k8s_namespace = each.value.k8s_namespace
  gcp_project_id = var.gcp_project_id
  roles = split(",", each.value.roles)
  gcp_location = var.gcp_region
}
