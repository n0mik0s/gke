provider "google" {}

provider "google-beta" {}

provider "kubernetes" {
  alias = "gke-1"
  host                   = "https://${module.gke-1.endpoint}"
  cluster_ca_certificate = base64decode(module.gke-1.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "kubernetes" {
  alias = "gke-2"
  host                   = "https://${module.gke-2.endpoint}"
  cluster_ca_certificate = base64decode(module.gke-2.cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

provider "helm" {
  alias = "gke-1"
  kubernetes {
    alias = "gke-1"
    host                   = "https://${module.gke-1.endpoint}"
    cluster_ca_certificate = base64decode(module.gke-1.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

provider "helm" {
  alias = "gke-2"
  kubernetes {
    alias = "gke-2"
    host                   = "https://${module.gke-2.endpoint}"
    cluster_ca_certificate = base64decode(module.gke-2.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}