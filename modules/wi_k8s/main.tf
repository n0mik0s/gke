resource "kubernetes_service_account" "main" {
  for_each = { for wi in var.wi_set : wi.name => wi if !tobool(wi.use_existing_k8s_sa) }

  automount_service_account_token = var.automount_service_account_token

  metadata {
    name      = each.value.name
    namespace = each.value.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = "${each.value.name}@${var.project_id}.iam.gserviceaccount.com"
    }
  }
}

module "annotate-sa" {
  for_each = { for wi in var.wi_set : wi.name => wi if tobool(wi.use_existing_k8s_sa) && tobool(wi.annotate_k8s_sa) }

  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 2.0.2"

  enabled          = each.value.use_existing_k8s_sa && each.value.annotate_k8s_sa
  skip_download    = true
  cluster_name     = var.cluster_name
  cluster_location = var.location
  project_id       = var.project_id

  kubectl_create_command  = "kubectl annotate --overwrite sa -n ${each.value.namespace} ${each.value.k8s_sa_name} iam.gke.io/gcp-service-account=${each.value.name}@${var.project_id}.iam.gserviceaccount.com}"
  kubectl_destroy_command = "kubectl annotate sa -n ${each.value.namespace} ${each.value.k8s_sa_name} iam.gke.io/gcp-service-account-"
}