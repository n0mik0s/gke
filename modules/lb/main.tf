locals {
  # https://www.googleapis.com/compute/v1/projects/telus-315414/zones/us-central1-c/instanceGroupManagers/gke-gke-1-gke-1-node-pool-26506d85-grp
  zones = toset([for i in var.instance_group_urls : join("", regex(".*?/zones/(.+)/instanceGroupManagers.*?$", tostring(i)))])
}

data "google_compute_network_endpoint_group" "pingdataconsole" {
  for_each = var.zones

  name    = var.lb_neg_name
  project = var.gcp_project_id
  zone    = each.value
}

resource "google_compute_global_address" "pingdataconsole" {
  name    = "pingdataconsole-global-ip"
  project = var.gcp_project_id
}

resource "google_compute_health_check" "pingdataconsole" {
  provider = google-beta
  project  = var.gcp_project_id
  name     = "pingdataconsole-health-check"

  https_health_check {
    port_specification = "USE_SERVING_PORT"
  }

  log_config {
    enable = true
  }
}

resource "google_compute_backend_service" "pingdataconsole" {
  name       = "pingdataconsole-backend-service"
  project    = var.gcp_project_id
  enable_cdn = true

  health_checks = [google_compute_health_check.pingdataconsole.id]

  session_affinity = "CLIENT_IP"
  protocol         = "HTTPS"
  timeout_sec      = 5

  log_config {
    enable = true
  }

  dynamic "backend" {
    for_each = local.zones
    content {
      balancing_mode = "RATE"
      max_rate       = 1
      group          = data.google_compute_network_endpoint_group.pingdataconsole[backend.value].id
    }
  }
}

resource "google_compute_global_forwarding_rule" "pingdataconsole" {
  provider              = google-beta
  project               = var.gcp_project_id
  name                  = "pingdataconsoleglobalrule"
  port_range            = var.lb_exposed_port
  target                = google_compute_target_https_proxy.pingdataconsole.id
  ip_address            = google_compute_global_address.pingdataconsole.address
  load_balancing_scheme = ""
}

resource "google_compute_ssl_certificate" "pingdataconsole" {
  name        = "pingdataconsole-certificate"
  project     = var.gcp_project_id
  private_key = file("certs/vetal.net.ua.key")
  certificate = file("certs/vetal.net.ua.crt")
}

resource "google_compute_target_https_proxy" "pingdataconsole" {
  provider         = google-beta
  project          = var.gcp_project_id
  name             = "pingdataconsole-target-https-proxy"
  url_map          = google_compute_url_map.pingdataconsole.id
  ssl_certificates = [google_compute_ssl_certificate.pingdataconsole.id]
}

resource "google_compute_url_map" "pingdataconsole" {
  provider        = google-beta
  project         = var.gcp_project_id
  name            = "pingdataconsole-url-map"
  default_service = google_compute_backend_service.pingdataconsole.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.pingdataconsole.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.pingdataconsole.id
    }
  }
}