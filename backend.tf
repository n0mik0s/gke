terraform {
  backend "gcs" {
    bucket  = "telus-tf-state-testing-Mykyta"
    prefix  = "state"
  }
}