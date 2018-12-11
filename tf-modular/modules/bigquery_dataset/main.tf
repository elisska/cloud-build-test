resource "google_bigquery_dataset" "zbra_dataset" {
  dataset_id    = "${var.bq_dataset_name}"
  friendly_name = "${var.bq_dataset_name}"
  location      = "US"
  project       = "${var.project}"

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
