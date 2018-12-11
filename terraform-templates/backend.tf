terraform {
  backend "gcs" {
    bucket = "es-s2dl-core-d-zbratech-tfstate"
    prefix = "terraform/state"
  }
}
