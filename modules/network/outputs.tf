output "network" {
  value = google_compute_network.network_ping_idm.id
}

output "subnetwork" {
  value = google_compute_subnetwork.subnetwork_ping_idm.id
}

output "cluster_secondary_range_name" {
  value = google_compute_subnetwork.subnetwork_ping_idm.secondary_ip_range.0.range_name
}

output "services_secondary_range_name" {
  value = google_compute_subnetwork.subnetwork_ping_idm.secondary_ip_range.1.range_name
}