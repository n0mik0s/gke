resource "helm_release" "pingfederate" {
  name             = "pingfederate"
  repository       = var.helm_repository
  chart            = var.helm_chart
  create_namespace = false
  namespace        = var.helm_namespace

  values = [
    "${file("manifests/pingfederate.yaml")}"
  ]

  depends_on = [kubernetes_secret.devops-secret]
}


resource "kubernetes_secret" "devops-secret" {
  metadata {
    namespace = var.helm_namespace
    name      = "devops-secret"
    annotations = {
      "ping-devops.app-version" = "v0.7.3"
      "ping-devops.user"        = var.ping_devops_user
    }
  }

  binary_data = {
    "PING_IDENTITY_ACCEPT_EULA" = "WUVT"
    "PING_IDENTITY_DEVOPS_KEY"  = var.ping_devops_key_bd
    "PING_IDENTITY_DEVOPS_USER" = var.ping_devops_user_bd
  }

  type = "Opaque"
}