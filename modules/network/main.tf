resource "google_compute_network" "network" {
  project = var.gcp_project_id
  name = var.network_name
  auto_create_subnetworks = false
  routing_mode = "GLOBAL"
}

resource "google_compute_firewall" "allow-ssh-to-bastion" {
  project = var.gcp_project_id
  name    = "allow-ssh-to-bastion"
  network = google_compute_network.network.name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = var.gcp_region
  project = var.gcp_project_id
  network = google_compute_network.network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  project = var.gcp_project_id
  name                               = "router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}