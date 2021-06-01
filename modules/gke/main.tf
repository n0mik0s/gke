/*
This module intended to create GKE cluster with non-default node pool.
In addition new namespaces could be created in the newly created cluster.

P.S. There is a small issue with namespaces deletion:
https://kubernetes.io/blog/2021/05/14/using-finalizers-to-control-deletion/
Please take a look: Forcing a Deletion of a Namespace.

P.P.S. In case of entire cluster deletion we could just delete appropriate
terraform state resource before running destroy command:
terraform state rm module.<cluster_name>.kubernetes_namespace.k8s_namespace[\"<namespace>\"]
*/

resource "google_service_account" "gke_nodes_sa" {
  account_id   = "gke-nodes-sa"
  display_name = "Service Account that belongs to the GKE node pool"
}

resource "google_container_cluster" "ping_idm" {
  name     = "ping-idm"
  location = var.gcp_region

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  cluster_autoscaling {
    enabled = false
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_enabled ? [1] : []
    content {
      identity_namespace = "${var.gcp_project_id}.svc.id.goog"
    }
  }

  remove_default_node_pool = true
  initial_node_count = var.initial_node_count
  default_max_pods_per_node = 8
}

resource "google_container_node_pool" "ping_idm_np" {
  name = "ping-idm-np"
  location = var.gcp_region
  cluster = google_container_cluster.ping_idm.name
  node_count = var.initial_node_count

  node_config {
    preemptible = true
    machine_type = var.machine_type
    disk_size_gb = 30

    dynamic "workload_metadata_config" {
      for_each = var.workload_identity_enabled ? [1] : []
      content {
        node_metadata = "GKE_METADATA_SERVER"
      }
    }

    service_account = google_service_account.gke_nodes_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}

resource "kubernetes_namespace" "k8s_namespace" {
  for_each = var.k8s_namespace_to_create

  metadata {
    labels = {
      cluster = google_container_cluster.ping_idm.name
    }

    name = each.value
  }
}