data "google_client_config" "default" {}

module "network" {
  source = "./modules/network"

  gcp_project_id = var.cluster.gcp_project_id
  gcp_region = var.cluster.gcp_region
  network_name = "${var.cluster.cluster_name}-net"
  ssh_destination_ranges = [var.bastion.primary_ip_cidr_range]
}

module "gke" {
  source = "./modules/gke"

  gcp_region = var.cluster.gcp_region
  gcp_project_id = var.cluster.gcp_project_id

  cluster_name = var.cluster.cluster_name
  cluster_location = var.cluster.cluster_location

  network = module.network.network_id
  primary_ip_cidr_range = var.cluster.primary_ip_cidr_range
  secondary_ip_range = var.cluster.secondary_ip_range
  master_ipv4_cidr_block = var.cluster.master_ipv4_cidr_block
  bastion_cidr_block = var.bastion.primary_ip_cidr_range

  workload_identity_enabled = var.cluster.workload_identity_enabled
  cluster_autoscaling = var.cluster.cluster_autoscaling
  memory_min = var.cluster.memory_min
  memory_max = var.cluster.memory_max
  cpu_min = var.cluster.cpu_min
  cpu_max = var.cluster.cpu_max
  initial_node_count = var.cluster.initial_node_count
  max_node_count = var.cluster.max_node_count
  min_node_count = var.cluster.min_node_count
  default_max_pods_per_node = var.cluster.default_max_pods_per_node
  machine_type = var.cluster.machine_type
  istio_config = var.cluster.istio_config

  k8s_namespaces = var.cluster.k8s_namespaces
}

module "workload_identity" {
  for_each = var.workload_identity_list

  source = "./modules/workload_identity"

  endpoint = module.gke.endpoint
  cluster_ca_certificate = module.gke.cluster_ca_certificate

  gcp_and_k8s_sa_names = each.value.gcp_and_k8s_sa_names
  k8s_namespace = each.value.k8s_namespace
  gcp_project_id = var.cluster.gcp_project_id
  roles = each.value.roles
  gcp_location = var.cluster.gcp_region
}

module "bastion" {
  source = "./modules/bastion"
  
  gcp_project_id = var.cluster.gcp_project_id
  gcp_region = var.cluster.gcp_region
  gcp_zone = var.bastion.gcp_zone

  primary_ip_cidr_range = var.bastion.primary_ip_cidr_range
  network = module.network.network_id

  machine_type = var.bastion.machine_type
}

module "ping" {
  source = "./modules/ping"
  count  = var.ping.helm_enabled ? 1 : 0

  helm_repository = var.ping.helm_repository
  helm_chart = var.ping.helm_chart
  ping_devops_user = var.ping.ping_devops_user
  ping_devops_key_bd = var.ping.ping_devops_key_bd
  ping_devops_user_bd = var.ping.ping_devops_user_bd
  namespace = var.ping.namespace

  depends_on = [module.workload_identity]
}
