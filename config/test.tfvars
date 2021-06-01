gcp_project_id = "telus-315414"

gcp_project_name = "telus-315414"

gcp_region = "northamerica-northeast1"

gcp_zone = "northamerica-northeast1-a"

prefix = "telus"

env = "test"

nodes_ip_cidr_range = "10.1.0.0/16"

pods_ip_cidr_range = "192.168.64.0/22"

svcs_ip_cidr_range = "192.168.1.0/24"

machine_type = "n1-standard-1"

initial_node_count = 1

workload_identity_enabled = true

k8s_namespace_to_create = ["test"]

workload_identity_map = {
    "ping_idm_federate" = {
        gcp_and_k8s_sa_names = "ping-idm-federate"
        k8s_namespace = "test"
        roles = "roles/storage.admin,roles/compute.admin"
    },
    "ping_idm_directory" = {
        gcp_and_k8s_sa_names = "ping-idm-directory"
        k8s_namespace = "test"
        roles = "roles/storage.admin,roles/compute.admin"
    }
}