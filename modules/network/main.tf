resource "google_compute_network" "network_ping_idm" {
  name                    = "network-ping-idm"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork_ping_idm" {
  name          = "subnetwork-ping-idm"
  ip_cidr_range = var.nodes_ip_cidr_range
  #region        = var.region
  network       = google_compute_network.network_ping_idm.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.svcs_ip_cidr_range
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.pods_ip_cidr_range
  }
}