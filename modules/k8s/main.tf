resource "kubernetes_namespace" "k8s_namespace" {
  for_each = var.namespaces

  metadata {
    labels = {
      cluster = var.cluster_name
    }

    annotations = {
      finalizers = ""
    }

    name = each.value
  }
}