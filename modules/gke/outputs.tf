output "endpoint" {
  value = google_container_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}

output "client_certificate" {
  value = google_container_cluster.cluster.master_auth[0].client_certificate
}

output "client_key" {
  value = google_container_cluster.cluster.master_auth[0].client_key
}

output "cluster_name" {
  value = google_container_cluster.cluster.name
}

output "cluster_location" {
  value = google_container_cluster.cluster.location
}

output "instance_group_urls" {
  value = google_container_node_pool.cluster_node_pool.instance_group_urls
}