provider "google" {}

provider "kubernetes" {
  host = "https://${module.gke_cluster_1.endpoint}"
  cluster_ca_certificate = base64decode(module.gke_cluster_1.cluster_ca_certificate)
  token = data.google_client_config.default.access_token
}

provider "kubernetes" {
  alias = "cluster_2"
  host = "https://${module.gke_cluster_2.endpoint}"
  cluster_ca_certificate = base64decode(module.gke_cluster_2.cluster_ca_certificate)
  token = data.google_client_config.default.access_token
}