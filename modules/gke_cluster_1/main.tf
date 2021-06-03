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
data "google_client_config" "default" {}

provider "kubernetes" {
  host = "https://${google_container_cluster.cluster.endpoint}"
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth[0].cluster_ca_certificate)
  token = data.google_client_config.default.access_token
}

locals {
  gke_cluster_is_regional = "${var.cluster_type == "regional" ? true : false}"

  k8s_sa_gcp_derived_name = "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.k8s_namespace}/${local.output_k8s_name}]"
  gcp_sa_email = google_service_account.cluster_service_account.email

  k8s_given_name = var.k8s_existing_sa_name != null ? var.k8s_existing_sa_name : var.gcp_and_k8s_sa_names
  output_k8s_name = tobool(var.use_existing_k8s_sa) ? local.k8s_given_name : kubernetes_service_account.main[0].metadata[0].name
  output_k8s_namespace = tobool(var.use_existing_k8s_sa) ? var.k8s_namespace : kubernetes_service_account.main[0].metadata[0].namespace
}

resource "google_service_account" "gke_nodes_sa" {
  project = var.gcp_project_id
  account_id = "${var.cluster_name}-gke-nodes-sa"
  display_name = "Service Account that belongs to the GKE node pool"
}

resource "google_compute_network" "network" {
  project = var.gcp_project_id
  name = "${var.cluster_name}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  project = var.gcp_project_id
  name = "${var.cluster_name}-subnet"
  ip_cidr_range = var.nodes_ip_cidr_range
  region = local.gke_cluster_is_regional ? var.cluster_location : ""

  network = google_compute_network.network.id
  secondary_ip_range {
    range_name = "services-range"
    ip_cidr_range = var.svcs_ip_cidr_range
  }

  secondary_ip_range {
    range_name = "pod-ranges"
    ip_cidr_range = var.pods_ip_cidr_range
  }
}

resource "google_container_cluster" "cluster" {
  project = var.gcp_project_id
  name = var.cluster_name
  location = var.cluster_location

  network = google_compute_network.network.id
  subnetwork = google_compute_subnetwork.subnetwork.id

  ip_allocation_policy {
    cluster_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name
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

resource "google_container_node_pool" "cluster_node_pool" {
  project = var.gcp_project_id
  name = "${var.cluster_name}-node_pool"
  location = var.cluster_location
  cluster = google_container_cluster.cluster.name
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
      cluster = google_container_cluster.cluster.name
    }

    name = each.value
  }
}

resource "google_service_account" "cluster_service_account" {
  account_id = substr(var.gcp_and_k8s_sa_names, 0, 30)
  display_name = substr("GCP SA bound to K8S SA ${local.k8s_given_name}", 0, 100)
  project = var.gcp_project_id
}

resource "kubernetes_service_account" "main" {
  count = tobool(var.use_existing_k8s_sa) ? 0 : 1

  automount_service_account_token = var.automount_service_account_token
  metadata {
    name = var.gcp_and_k8s_sa_names
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.cluster_service_account.email
    }
  }
}

module "annotate-sa" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.0.2"

  enabled = tobool(var.use_existing_k8s_sa) && var.annotate_k8s_sa
  skip_download = true
  cluster_name = var.cluster_name
  cluster_location = var.cluster_location
  project_id = var.gcp_project_id

  kubectl_create_command = "kubectl annotate --overwrite sa -n ${local.output_k8s_namespace} ${local.k8s_given_name} iam.gke.io/gcp-service-account=${local.gcp_sa_email}"
  kubectl_destroy_command = "kubectl annotate sa -n ${local.output_k8s_namespace} ${local.k8s_given_name} iam.gke.io/gcp-service-account-"
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.cluster_service_account.name
  role = "roles/iam.workloadIdentityUser"
  member = local.k8s_sa_gcp_derived_name
}

resource "google_project_iam_member" "workload_identity_sa_bindings" {
  for_each = toset(var.roles)

  project = var.gcp_project_id
  role = each.value
  member = "serviceAccount:${google_service_account.cluster_service_account.email}"
}