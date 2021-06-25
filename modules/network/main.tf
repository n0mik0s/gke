resource "google_compute_network" "network" {
  project                 = var.gcp_project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "firewall" {
  project = var.gcp_project_id
  name    = "${var.network_name}-allow-all"
  network = google_compute_network.network.name

  direction = "INGRESS"

  allow {
    protocol = "all"
  }
}

resource "google_compute_router" "router" {
  for_each = var.gcp_regions

  name    = "router-${each.value}"
  region  = each.value
  project = var.gcp_project_id
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "router_nat" {
  for_each = var.gcp_regions

  project                            = var.gcp_project_id
  name                               = "router-nat-${each.value}"
  router                             = google_compute_router.router[each.key].name
  region                             = google_compute_router.router[each.key].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}