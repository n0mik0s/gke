terraform {
  backend "gcs" {
    bucket = "telus-tf-remote-state"
    prefix = "state"
  }
}