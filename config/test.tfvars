#--------------------------------------------------------------
# General
#--------------------------------------------------------------
gcp_project_id             = ""
ping_devops_user_plain     = ""
ping_devops_key_encrypted  = ""
ping_devops_user_encrypted = ""

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
network_name = "gke-1-2-mrc"

network_gke-1_primary_ip_cidr_range   = "10.162.0.0/20"
network_gke-1_master_ipv4_cidr_block  = "172.16.0.0/28"
network_gke-1_secondary_ip_range_svc  = "10.60.0.0/20"
network_gke-1_secondary_ip_range_pods = "10.56.0.0/14"

network_gke-2_primary_ip_cidr_range   = "10.128.0.0/20"
network_gke-2_master_ipv4_cidr_block  = "172.17.0.0/28"
network_gke-2_secondary_ip_range_svc  = "10.80.0.0/20"
network_gke-2_secondary_ip_range_pods = "10.76.0.0/14"

#--------------------------------------------------------------
# GKE
#--------------------------------------------------------------
cluster_gke-1_name           = "gke-1"
cluster_gke-1_location       = "us-central1"
cluster_gke-1_region         = "us-central1"
cluster_gke-1_node_locations = ["us-central1-a", "us-central1-b", "us-central1-c"]

cluster_gke-2_name           = "gke-2"
cluster_gke-2_location       = "northamerica-northeast1"
cluster_gke-2_region         = "northamerica-northeast1"
cluster_gke-2_node_locations = ["northamerica-northeast1-a", "northamerica-northeast1-b", "northamerica-northeast1-c"]

cluster_autoscaling               = true
cluster_type                      = "regional"
cluster_machine_type              = "n1-standard-1"
cluster_default_max_pods_per_node = 30
cluster_workload_identity_enabled = true
cluster_k8s_namespaces            = ["gke-1", "gke-2"]
cluster_istio_config              = true
cluster_master_authorized_network = "0.0.0.0/0"

cluster_initial_node_count = 1
cluster_cpu_min            = 3
cluster_cpu_max            = 6
cluster_memory_min         = 8
cluster_memory_max         = 24
cluster_min_node_count     = 1
cluster_max_node_count     = 2
#--------------------------------------------------------------
# Workload Identity
#--------------------------------------------------------------
wi_gke-1_set = [
  {
    name                = "gke-1-storage-sa"
    namespace           = "gke-1"
    roles               = "roles/storage.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-1-compute-sa"
    namespace           = "gke-1"
    roles               = "roles/compute.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-1-dns-sa"
    namespace           = "gke-1"
    roles               = "roles/dns.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  }
]

wi_gke-2_set = [
  {
    name                = "gke-2-storage-sa"
    namespace           = "gke-2"
    roles               = "roles/storage.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-2-compute-sa"
    namespace           = "gke-2"
    roles               = "roles/compute.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-2-dns-sa"
    namespace           = "gke-2"
    roles               = "roles/dns.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  }
]
#--------------------------------------------------------------
# Helm
#--------------------------------------------------------------
helm_enabled    = false
helm_repository = "https://helm.pingidentity.com/"
helm_chart      = "ping-devops"
helm_namespace  = "test"
#--------------------------------------------------------------
# Bastion
#--------------------------------------------------------------
bastion_enabled             = false
bastion_gke-1_ip_cidr_range = "192.168.10.0/24"
bastion_gke-2_ip_cidr_range = "192.168.11.0/24"
bastion_machine_type        = "n1-standard-1"
#--------------------------------------------------------------
# LB
#--------------------------------------------------------------
lb_enabled      = true
lb_exposed_port = 443
lb_neg_name     = "pingdataconsole-https-neg"
lb_service_name = "pingdataconsole"
#--------------------------------------------------------------
# K8s
#--------------------------------------------------------------
k8s_enabled      = true
k8s_svc_instance = "pf"
k8s_svc_enabled  = true
#--------------------------------------------------------------
# MCS
#--------------------------------------------------------------
mcs_enabled = true