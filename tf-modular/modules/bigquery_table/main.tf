resource "google_bigquery_table" "zbra_table" {
  dataset_id = "${var.bq_dataset_name}"
  table_id   = "${var.bq_dataset_table_name}"
  project    = "${var.project}"

  schema = "${file("../bq_schemas/${var.app_name}_${var.bq_dataset_table_name}.json")}"

  time_partitioning {
    type = "DAY"
    field = "${var.time_partitioning_column}"
  }

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
