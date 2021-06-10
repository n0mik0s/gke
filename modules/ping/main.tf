resource "kubernetes_secret" "devops-secret" {
  metadata {
    namespace = "test"
    name = "devops-secret"
    annotations = {
      "ping-devops.app-version" = "v0.7.3"
      "ping-devops.user" = var.ping_devops_user
    }
  }

  binary_data = {
    "PING_IDENTITY_ACCEPT_EULA" = "WUVT"
    "PING_IDENTITY_DEVOPS_KEY" = var.ping_devops_key_bd
    "PING_IDENTITY_DEVOPS_USER" = var.ping_devops_user_bd
  }

  type = "Opaque"
}

resource "helm_release" "pingfederate" {
  name = "pingfederate"
  repository = var.helm_repository
  chart = var.helm_chart
  create_namespace = true
  namespace = var.namespace

  values = [
    "${file("pingfederate.yaml")}"
  ]

  depends_on = [kubernetes_secret.devops-secret]
}