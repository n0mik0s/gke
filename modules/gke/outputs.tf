output "endpoint" {
  value       = google_container_cluster.ping_idm.endpoint
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.ping_idm.master_auth[0].cluster_ca_certificate
}
