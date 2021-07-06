locals {
  annotation = "{\"exposed_ports\": {\"${var.lb_exposed_port}\": {\"name\": \"${var.lb_neg_name}\"}}}"
}

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

resource "kubernetes_service" "nginx" {
  metadata {
    namespace = var.helm_namespace
    name      = "pingdataconsole-https"

    annotations = {
      "cloud.google.com/neg" = local.annotation
      "meta.helm.sh/release-name" : "pingfederate"
      "meta.helm.sh/release-namespace" : var.helm_namespace
      "app.kubernetes.io/instance" : "pingfederate"
      "app.kubernetes.io/managed-by" : "Helm"
      "app.kubernetes.io/name" : "pingdataconsole"
      "helm.sh/chart" : "ping-devops-0.6.3"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/instance" : "pingfederate"
      "app.kubernetes.io/name" : "pingdataconsole"
    }

    session_affinity = "ClientIP"

    port {
      protocol    = "TCP"
      port        = 443
      target_port = 8443
    }

    type = "ClusterIP"
  }

  depends_on = [helm_release.pingfederate]
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