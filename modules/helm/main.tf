resource "helm_release" "pingfederate" {
  name             = "pingfederate"
  repository       = var.helm_repository
  chart            = var.helm_chart
  create_namespace = false
  namespace        = var.helm_namespace

  timeout = 600

  values = [
    "${file("manifests/pingfederate.yaml")}"
  ]
}