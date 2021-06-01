provider "google" {
  project = var.gcp_project_id
  region = var.gcp_region
  zone = var.gcp_zone
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}