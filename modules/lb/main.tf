resource "time_sleep" "wait" {
  create_duration = "10m"
}

data "google_compute_network_endpoint_group" "network_endpoint_group" {
  for_each = var.zones

  name    = var.lb_neg_name
  project = var.gcp_project_id
  zone    = each.value

  depends_on = [time_sleep.wait]
}

resource "google_compute_global_address" "global_address" {
  name    = "${var.service_name}-global-ip"
  project = var.gcp_project_id
}

resource "google_compute_health_check" "health_check" {
  provider = google-beta
  project  = var.gcp_project_id
  name     = "${var.service_name}-health-check"

  https_health_check {
    port_specification = "USE_SERVING_PORT"
  }

  log_config {
    enable = true
  }
}

resource "google_compute_backend_service" "backend_service" {
  name       = "${var.service_name}-backend-service"
  project    = var.gcp_project_id
  enable_cdn = true

  health_checks = [google_compute_health_check.health_check.id]

  session_affinity = "CLIENT_IP"
  protocol         = "HTTPS"
  timeout_sec      = 60

  log_config {
    enable = true
  }

  dynamic "backend" {
    for_each = var.zones

    content {
      balancing_mode = "RATE"
      max_rate       = 1
      group          = data.google_compute_network_endpoint_group.network_endpoint_group[backend.value].id
    }
  }
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  provider              = google-beta
  project               = var.gcp_project_id
  name                  = "${var.service_name}globalrule"
  port_range            = var.lb_exposed_port
  target                = google_compute_target_https_proxy.target_https_proxy.id
  ip_address            = google_compute_global_address.global_address.address
  load_balancing_scheme = ""

  lifecycle {
    ignore_changes = all
  }
}

resource "google_compute_ssl_certificate" "ssl_certificate" {
  name        = "${var.service_name}-certificate"
  project     = var.gcp_project_id
  private_key = file("certs/vetal.net.ua.key")
  certificate = file("certs/vetal.net.ua.crt")
}

resource "google_compute_target_https_proxy" "target_https_proxy" {
  provider         = google-beta
  project          = var.gcp_project_id
  name             = "${var.service_name}-target-https-proxy"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_ssl_certificate.ssl_certificate.id]
}

resource "google_compute_url_map" "url_map" {
  provider        = google-beta
  project         = var.gcp_project_id
  name            = "${var.service_name}-url-map"
  default_service = google_compute_backend_service.backend_service.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend_service.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backend_service.id
    }
  }
}