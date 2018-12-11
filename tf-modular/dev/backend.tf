terraform {
  backend "gcs" {
    bucket = "es-s2dl-core-d-zbratech-tfstate-spg-zpc"
    prefix = "terraform/state"
  }
}
