#--------------------------------------------------------------
# General
#--------------------------------------------------------------
gcp_project_id             = "telus-test-01"
ping_devops_user_plain     = ""
ping_devops_key_encrypted  = ""
ping_devops_user_encrypted = ""

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
network_name = "gke-sr-cluster"

network_primary_ip_cidr_range   = "10.162.0.0/20"
network_master_ipv4_cidr_block  = "172.16.0.0/28"
network_secondary_ip_range_svc  = "10.60.0.0/20"
network_secondary_ip_range_pods = "10.56.0.0/14"

#--------------------------------------------------------------
# GKE
#--------------------------------------------------------------
cluster_name           = "gke"
cluster_location       = "northamerica-northeast1"
cluster_region         = "northamerica-northeast1"
cluster_node_locations = ["northamerica-northeast1-a", "northamerica-northeast1-b", "northamerica-northeast1-c"]

cluster_autoscaling               = true
cluster_type                      = "regional"
cluster_machine_type              = "n1-standard-1"
cluster_default_max_pods_per_node = 30
cluster_workload_identity_enabled = true
cluster_k8s_namespaces            = ["gke"]
cluster_istio_config              = false
cluster_master_authorized_network = "0.0.0.0/0"

cluster_initial_node_count = 2
cluster_cpu_min            = 6
cluster_cpu_max            = 12
cluster_memory_min         = 7
cluster_memory_max         = 48
cluster_min_node_count     = 2
cluster_max_node_count     = 4
#--------------------------------------------------------------
# Workload Identity
#--------------------------------------------------------------
wi_set = [
  {
    name                = "gke-storage-sa"
    namespace           = "gke"
    roles               = "roles/storage.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-compute-sa"
    namespace           = "gke"
    roles               = "roles/compute.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-dns-sa"
    namespace           = "gke"
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
helm_namespace  = "gke"
#--------------------------------------------------------------
# Bastion
#--------------------------------------------------------------
bastion_enabled       = false
bastion_ip_cidr_range = "192.168.10.0/24"
bastion_machine_type  = "n1-standard-1"
#--------------------------------------------------------------
# LB
#--------------------------------------------------------------
lb_enabled      = false
lb_exposed_port = 443
lb_neg_name     = "pingdataconsole-https-neg"
lb_service_name = "pingdataconsole"
#--------------------------------------------------------------
# K8s
#--------------------------------------------------------------
k8s_enabled      = true
k8s_svc_instance = "pingfederate"
k8s_svc_enabled  = false