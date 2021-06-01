locals {
  k8s_sa_gcp_derived_name = "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.k8s_namespace}/${local.output_k8s_name}]"
  gcp_sa_email            = google_service_account.cluster_service_account.email

  k8s_given_name       = var.k8s_existing_sa_name != null ? var.k8s_existing_sa_name : var.gcp_and_k8s_sa_names
  output_k8s_name      = tobool(var.use_existing_k8s_sa) ? local.k8s_given_name : kubernetes_service_account.main[0].metadata[0].name
  output_k8s_namespace = tobool(var.use_existing_k8s_sa) ? var.k8s_namespace : kubernetes_service_account.main[0].metadata[0].namespace
}

resource "google_service_account" "cluster_service_account" {
  account_id   = substr(var.gcp_and_k8s_sa_names, 0, 30)
  display_name = substr("GCP SA bound to K8S SA ${local.k8s_given_name}", 0, 100)
  project      = var.gcp_project_id
}

resource "kubernetes_service_account" "main" {
  count = tobool(var.use_existing_k8s_sa) ? 0 : 1

  automount_service_account_token = var.automount_service_account_token
  metadata {
    name      = var.gcp_and_k8s_sa_names
    namespace = var.k8s_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.cluster_service_account.email
    }
  }
}

module "annotate-sa" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.0.2"

  enabled          = tobool(var.use_existing_k8s_sa) && var.annotate_k8s_sa
  skip_download    = true
  cluster_name     = var.cluster_name
  cluster_location = var.gcp_location
  project_id       = var.gcp_project_id

  kubectl_create_command  = "kubectl annotate --overwrite sa -n ${local.output_k8s_namespace} ${local.k8s_given_name} iam.gke.io/gcp-service-account=${local.gcp_sa_email}"
  kubectl_destroy_command = "kubectl annotate sa -n ${local.output_k8s_namespace} ${local.k8s_given_name} iam.gke.io/gcp-service-account-"
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.cluster_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_sa_gcp_derived_name
}


resource "google_project_iam_member" "workload_identity_sa_bindings" {
  for_each = toset(var.roles)

  project = var.gcp_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}