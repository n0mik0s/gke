cluster = {
    gcp_project_id = "telus-315414"
    cluster_type = "regional"
    cluster_autoscaling = true
    cluster_name = "ping-idm"
    cpu_min = 3
    cpu_max = 6
    memory_min = 8
    memory_max = 24
    min_node_count = 1
    max_node_count = 2
    gcp_region = "us-west1"
    cluster_location = "us-west1"
    subnetwork_name = "gke"
    primary_ip_cidr_range = "10.1.1.0/24"
    master_ipv4_cidr_block = "172.16.0.0/28"
    secondary_ip_range = [
        {
            "ip_cidr_range": "192.168.10.0/24"
            "range_name": "services-range"
        },
        {
            "ip_cidr_range": "192.168.11.0/24"
            "range_name": "pod-ranges"
        }
    ]
    machine_type = "n1-standard-1"
    initial_node_count = 1
    default_max_pods_per_node = 30
    workload_identity_enabled = true
    k8s_namespaces = ["test"]
    istio_config = true
}

workload_identity_list = {
    "ping-idm-federate" = {
        gcp_and_k8s_sa_names = "ping-idm-federate"
        k8s_namespace = "test"
        roles = ["roles/storage.admin", "roles/compute.admin"]
    }
}

bastion = {
    gcp_zone = "us-west1-a"
    primary_ip_cidr_range = "10.2.1.0/24"
    machine_type = "n1-standard-1"
}

ping = {
    helm_enabled = true
    helm_repository = "https://helm.pingidentity.com/"
    helm_chart = "ping-devops"
    ping_devops_user = "vitalii_kalinichenko@epam.com"
    ping_devops_key_bd = "YzNlMDExYWUtZTc5OC1mZWFjLTExMGQtMjA4NzIwOTIwODM5"
    ping_devops_user_bd = "dml0YWxpaV9rYWxpbmljaGVua29AZXBhbS5jb20="
    namespace = "test"
}