data "google_client_config" "default" {}

module "network" {
  source = "./modules/network"

  gcp_project_id = var.gcp_project_id
  gcp_regions = [
    var.cluster_gke-1_location,
    var.cluster_gke-2_location
  ]

  network_name = var.network_name
}

module "gke-1" {
  source = "./modules/gke"

  gcp_project_id            = var.gcp_project_id
  cluster_location          = var.cluster_gke-1_location
  cluster_region            = var.cluster_gke-1_region
  cluster_name              = var.cluster_gke-1_name
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
  primary_ip_cidr_range     = var.network_gke-1_primary_ip_cidr_range
  master_ipv4_cidr_block    = var.network_gke-1_master_ipv4_cidr_block
  secondary_ip_range_svc    = var.network_gke-1_secondary_ip_range_svc
  secondary_ip_range_pods   = var.network_gke-1_secondary_ip_range_pods
}

module "gke-2" {
  source = "./modules/gke"

  gcp_project_id            = var.gcp_project_id
  cluster_location          = var.cluster_gke-2_location
  cluster_region            = var.cluster_gke-2_region
  cluster_name              = var.cluster_gke-2_name
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
  primary_ip_cidr_range     = var.network_gke-2_primary_ip_cidr_range
  master_ipv4_cidr_block    = var.network_gke-2_master_ipv4_cidr_block
  secondary_ip_range_svc    = var.network_gke-2_secondary_ip_range_svc
  secondary_ip_range_pods   = var.network_gke-2_secondary_ip_range_pods
}

module "k8s-gke-1" {
  source = "./modules/k8s"
  count  = var.k8s_enabled ? 1 : 0

  providers = {
    kubernetes = kubernetes.gke-1
  }

  namespaces     = var.cluster_k8s_namespaces
  helm_namespace = var.helm_namespace
  cluster_name   = module.gke-1.cluster_name
}

module "k8s-gke-2" {
  source = "./modules/k8s"
  count  = var.k8s_enabled ? 1 : 0

  providers = {
    kubernetes = kubernetes.gke-2
  }

  namespaces     = var.cluster_k8s_namespaces
  helm_namespace = var.helm_namespace
  cluster_name   = module.gke-2.cluster_name
}

module "wi_k8s-gke-1" {
  source = "./modules/wi_k8s"

  providers = {
    kubernetes = kubernetes.gke-1
  }

  wi_set       = var.wi_gke-1_set
  project_id   = var.gcp_project_id
  cluster_name = module.gke-1.cluster_name
  location     = module.gke-1.cluster_location
}

module "wi_gsa-gke-1" {
  source   = "./modules/wi_gsa"
  for_each = { for wi in var.wi_gke-1_set : wi.name => wi }

  name           = each.value.name
  namespace      = each.value.namespace
  roles          = split(",", each.value.roles)
  k8s_given_name = each.value.k8s_sa_name != null ? each.value.k8s_sa_name : each.value.name
  project_id     = var.gcp_project_id
}

module "wi_k8s-gke-2" {
  source = "./modules/wi_k8s"

  providers = {
    kubernetes = kubernetes.gke-2
  }

  wi_set       = var.wi_gke-2_set
  project_id   = var.gcp_project_id
  cluster_name = module.gke-2.cluster_name
  location     = module.gke-2.cluster_location
}

module "wi_gsa-gke-2" {
  source   = "./modules/wi_gsa"
  for_each = { for wi in var.wi_gke-2_set : wi.name => wi }

  name           = each.value.name
  namespace      = each.value.namespace
  roles          = split(",", each.value.roles)
  k8s_given_name = each.value.k8s_sa_name != null ? each.value.k8s_sa_name : each.value.name
  project_id     = var.gcp_project_id
}

module "bastion-1" {
  source = "./modules/bastion"
  count  = var.bastion_enabled ? 1 : 0

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.cluster_gke-1_region
  gcp_zone       = "${var.cluster_gke-1_region}-a"

  cluster_name = module.gke-1.cluster_name

  primary_ip_cidr_range = var.bastion_gke-1_ip_cidr_range
  network               = module.network.network_id

  machine_type = var.bastion_machine_type
}

module "bastion-2" {
  source = "./modules/bastion"
  count  = var.bastion_enabled ? 1 : 0

  gcp_project_id = var.gcp_project_id
  gcp_region     = var.cluster_gke-2_region
  gcp_zone       = "${var.cluster_gke-2_region}-a"

  cluster_name = module.gke-2.cluster_name

  primary_ip_cidr_range = var.bastion_gke-2_ip_cidr_range
  network               = module.network.network_id

  machine_type = var.bastion_machine_type
}

module "lb" {
  source = "./modules/lb"
  count  = var.lb_enabled ? 1 : 0

  lb_exposed_port = var.lb_exposed_port
  lb_neg_name     = var.lb_neg_name
  gcp_project_id  = var.gcp_project_id

  instance_group_urls = flatten([
    module.gke-1.instance_group_urls,
    module.gke-2.instance_group_urls
  ])
}

module "helm-gke-1" {
  source = "./modules/helm"
  count  = var.helm_enabled ? 1 : 0

  providers = {
    helm       = helm.gke-1
    kubernetes = kubernetes.gke-1
  }

  helm_chart      = var.helm_chart
  helm_namespace  = var.helm_namespace
  helm_repository = var.helm_repository

  ping_devops_user    = var.ping_devops_user
  ping_devops_key_bd  = var.ping_devops_key_bd
  ping_devops_user_bd = var.ping_devops_user_bd
}

module "helm-gke-2" {
  source = "./modules/helm"
  count  = var.helm_enabled ? 1 : 0

  providers = {
    helm       = helm.gke-2
    kubernetes = kubernetes.gke-2
  }

  helm_chart      = var.helm_chart
  helm_namespace  = var.helm_namespace
  helm_repository = var.helm_repository

  ping_devops_user    = var.ping_devops_user
  ping_devops_key_bd  = var.ping_devops_key_bd
  ping_devops_user_bd = var.ping_devops_user_bd
}

module "mcs" {
  source = "terraform-google-modules/gcloud/google"
  count  = var.mcs_enabled ? 1 : 0

  platform = "linux"

  create_cmd_entrypoint = "${path.module}/scripts/mcs_enable.sh"
  create_cmd_body       = "${var.gcp_project_id} ${var.cluster_gke-1_name} ${var.cluster_gke-1_location} ${var.cluster_gke-2_name} ${var.cluster_gke-2_location}"

  destroy_cmd_entrypoint = "${path.module}/scripts/mcs_disable.sh"
  destroy_cmd_body       = "${var.gcp_project_id} ${var.cluster_gke-1_name} ${var.cluster_gke-1_location} ${var.cluster_gke-2_name} ${var.cluster_gke-2_location}"
}