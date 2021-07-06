terraform {
  backend "gcs" {
    bucket = "telus-mr-gke"
    prefix = "state"
  }
}