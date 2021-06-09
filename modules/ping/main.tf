resource "kubernetes_secret" "devops-secret" {
  metadata {
    namespace = "test"
    name = "devops-secret"
    annotations = {
      "ping-devops.app-version" = "v0.7.3"
      "ping-devops.user" = "vitalii_kalinichenko@epam.com"
    }
  }

  binary_data = {
    "PING_IDENTITY_ACCEPT_EULA" = "WUVT"
    "PING_IDENTITY_DEVOPS_KEY" = "YzNlMDExYWUtZTc5OC1mZWFjLTExMGQtMjA4NzIwOTIwODM5"
    "PING_IDENTITY_DEVOPS_USER" = "dml0YWxpaV9rYWxpbmljaGVua29AZXBhbS5jb20="
  }

  type = "Opaque"
}

resource "helm_release" "pingfederate" {
  name = "pingfederate"
  repository = var.helm_repository
  chart = var.helm_chart
  create_namespace = true
  namespace = "test"

  values = [
    "${file("pingfederate.yaml")}"
  ]

  depends_on = [kubernetes_secret.devops-secret]
}