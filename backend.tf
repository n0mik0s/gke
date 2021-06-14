terraform {
  backend "gcs" {
    bucket = "telus-tf-state"
    prefix = "state"
  }
}