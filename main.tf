data "google_client_config" "default" {}

module "network" {
  source = "./modules/network"

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.cluster_region

  network_name = var.network_name
}

module "gke" {
  source = "./modules/gke"

  gcp_project_id            = var.gcp_project_id
  cluster_location          = var.cluster_location
  cluster_node_locations    = var.cluster_node_locations
  cluster_region            = var.cluster_region
  cluster_name              = var.cluster_name
  cluster_autoscaling       = var.cluster_autoscaling
  cluster_type              = var.cluster_type
  machine_type              = var.cluster_machine_type
  workload_identity_enabled = var.cluster_workload_identity_enabled
  istio_config              = var.cluster_istio_config

  default_max_pods_per_node = var.cluster_default_max_pods_per_node
  initial_node_count        = var.cluster_initial_node_count
  cpu_min                   = var.cluster_cpu_min
  cpu_max                   = var.cluster_cpu_max
  memory_min                = var.cluster_memory_min
  memory_max                = var.cluster_memory_max
  min_node_count            = var.cluster_min_node_count
  max_node_count            = var.cluster_max_node_count

  network                   = module.network.network_id
  master_authorized_network = var.cluster_master_authorized_network
  primary_ip_cidr_range     = var.network_primary_ip_cidr_range
  master_ipv4_cidr_block    = var.network_master_ipv4_cidr_block
  secondary_ip_range_svc    = var.network_secondary_ip_range_svc
  secondary_ip_range_pods   = var.network_secondary_ip_range_pods
}

module "k8s" {
  source = "./modules/k8s"
  count  = var.k8s_enabled ? 1 : 0

  namespaces     = var.cluster_k8s_namespaces
  helm_namespace = var.helm_namespace
  cluster_name   = module.gke.cluster_name

  lb_exposed_port = var.lb_exposed_port
  lb_neg_name     = var.lb_neg_name
  svc_instance    = var.k8s_svc_instance
  svc_enabled     = var.k8s_svc_enabled

  ping_devops_user_plain     = var.ping_devops_user_plain
  ping_devops_key_encrypted  = var.ping_devops_key_encrypted
  ping_devops_user_encrypted = var.ping_devops_user_encrypted

  svc_namespaces = var.cluster_k8s_namespaces
}

module "wi_k8s" {
  source = "./modules/wi_k8s"

  wi_set       = var.wi_set
  project_id   = var.gcp_project_id
  cluster_name = module.gke.cluster_name
  location     = module.gke.cluster_location
}

module "wi_gsa" {
  source   = "./modules/wi_gsa"
  for_each = { for wi in var.wi_set : wi.name => wi }

  name           = each.value.name
  namespace      = each.value.namespace
  roles          = split(",", each.value.roles)
  k8s_given_name = each.value.k8s_sa_name != null ? each.value.k8s_sa_name : each.value.name
  project_id     = var.gcp_project_id
}

module "bastion" {
  source = "./modules/bastion"
  count  = var.bastion_enabled ? 1 : 0

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.cluster_region
  gcp_zone       = "${var.cluster_region}-a"

  cluster_name = module.gke.cluster_name

  primary_ip_cidr_range = var.bastion_ip_cidr_range
  network               = module.network.network_id

  machine_type = var.bastion_machine_type
}

module "lb" {
  source = "./modules/lb"
  count  = var.lb_enabled ? 1 : 0

  lb_exposed_port = var.lb_exposed_port
  lb_neg_name     = var.lb_neg_name
  service_name    = var.lb_service_name
  gcp_project_id  = var.gcp_project_id

  zones = flatten(var.cluster_node_locations)

  depends_on = [
    module.k8s
  ]
}

module "helm" {
  source = "./modules/helm"
  count  = var.helm_enabled ? 1 : 0

  helm_chart      = var.helm_chart
  helm_namespace  = var.helm_namespace
  helm_repository = var.helm_repository

  depends_on = [module.k8s]
}