locals {
  annotation = "{\"exposed_ports\": {\"${var.lb_exposed_port}\": {\"name\": \"${var.lb_neg_name}\"}}}"
}

resource "time_sleep" "wait" {
  # We need to wait up to 10 minutes that all NEGs that were created in k8s module could be
  # available for adding them to the backend service
  create_duration = "3m"
}

resource "kubernetes_namespace" "k8s_namespace" {
  for_each = var.namespaces

  metadata {
    labels = {
      cluster = var.cluster_name
    }

    annotations = {
      finalizers = null
    }

    name = each.value
  }

  depends_on = [time_sleep.wait]
}

resource "kubernetes_secret" "devops-secret" {
  for_each = var.namespaces

  metadata {
    namespace = each.value
    name      = "devops-secret"
    annotations = {
      "ping-devops.app-version" = "v0.7.3"
      "ping-devops.user"        = var.ping_devops_user_plain
    }
  }

  binary_data = {
    "PING_IDENTITY_ACCEPT_EULA" = "WUVT"
    "PING_IDENTITY_DEVOPS_KEY"  = var.ping_devops_key_encrypted
    "PING_IDENTITY_DEVOPS_USER" = var.ping_devops_user_encrypted
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.k8s_namespace]
}

resource "kubernetes_service" "kubernetes_service" {
  for_each = toset([for i in var.svc_namespaces : i if var.svc_enabled])

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata {
    namespace = each.value
    name      = "${var.svc_instance}-pingdataconsole-https"

    annotations = {
      "cloud.google.com/neg" = local.annotation
      "meta.helm.sh/release-name" : var.svc_instance
      "meta.helm.sh/release-namespace" : each.value
      "app.kubernetes.io/instance" : var.svc_instance
      "app.kubernetes.io/managed-by" : "Helm"
      "app.kubernetes.io/name" : "pingdataconsole"
      "helm.sh/chart" : "ping-devops-0.6.3"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/instance" : var.svc_instance
      "app.kubernetes.io/name" : "pingdataconsole"
    }

    session_affinity = "ClientIP"

    port {
      name        = "pingfederate-https"
      protocol    = "TCP"
      port        = 443
      target_port = 8443
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_namespace.k8s_namespace]
}