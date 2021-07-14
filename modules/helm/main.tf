/*
  This module is intended to install Ping Identity components via helm charts
*/

resource "helm_release" "pingfederate" {
  name             = "pingfederate"
  repository       = var.helm_repository
  chart            = var.helm_chart
  create_namespace = false
  namespace        = var.helm_namespace

  timeout = 600

  values = [
    # The file with all values that should override the default values for the chart:
    "${file("manifests/pingfederate.yaml")}"
  ]
}