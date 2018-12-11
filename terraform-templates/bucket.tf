resource "google_storage_bucket" "zebra_dataflow_temp" {
  name     = "zebra-${var.env}-dataflow-temp"
  location = "${var.region}"
  project  = "${var.project}"

  labels {
    env                 = "${var.env}"
    buownertechnical    = "ec5485"
    buownermanager      = "jhand"
    costcenter          = "36056"
    tier                = "development"
    projectorproduct    = "visibility_services"
    securityagentxxempt = "none"
  }
}
