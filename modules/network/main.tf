/*
  This module intended to create a network that would be used for GKE clusters.
  Next VPC related resources will be created via this module:
  - Firewall rule(s)
  - VPC router for router NAT that will be used by the GKE nodes for egress traffic
  - Router NAT itself
*/

resource "google_compute_network" "network" {
  # The main concept regarding the GCP VPC could be found here:
  # https://cloud.google.com/vpc
  project                 = var.gcp_project_id
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_firewall" "firewall" {
  # The main concept regarding the GCP VPC firewall could be found here:
  # https://cloud.google.com/firewalls
  # https://cloud.google.com/vpc/docs/firewalls
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

  name    = "router-${var.network_name}-${each.value}"
  region  = each.value
  project = var.gcp_project_id
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "router_nat" {
  # The main concept regarding the GCP VPC router NAT could be found here:
  # https://cloud.google.com/nat/docs/overview
  # https://cloud.google.com/nat/docs/using-nat
  for_each = var.gcp_regions

  project                            = var.gcp_project_id
  name                               = "router-nat-${var.network_name}-${each.value}"
  router                             = google_compute_router.router[each.key].name
  region                             = google_compute_router.router[each.key].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}