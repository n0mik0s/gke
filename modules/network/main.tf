locals {
  network_name    = "${var.cluster_name}-net"
  firewall_name   = "${var.cluster_name}-allow-all"
  router_name     = "${var.cluster_name}-router"
  router_nat_name = "${var.cluster_name}-router-nat"
}


resource "google_compute_network" "network" {
  project                 = var.gcp_project_id
  name                    = local.network_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "firewall" {
  project = var.gcp_project_id
  name    = local.firewall_name
  network = google_compute_network.network.name

  direction = "INGRESS"

  allow {
    protocol = "all"
  }
}

resource "google_compute_router" "router" {
  name    = local.router_name
  region  = var.gcp_region
  project = var.gcp_project_id
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "router_nat" {
  project                            = var.gcp_project_id
  name                               = local.router_nat_name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}