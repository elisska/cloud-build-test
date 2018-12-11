resource "google_bigquery_dataset" "zebra_dataset" {
  dataset_id    = "zebra_${var.env}_dataset"
  friendly_name = "zebra_${var.env}_dataset"
  description   = "Zebra BigQuery dataset"
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

  depends_on = [
    "google_storage_bucket.zebra_dataflow_temp",
  ]
}

resource "google_bigquery_table" "zebra_table" {
  dataset_id = "${google_bigquery_dataset.zebra_dataset.dataset_id}"
  table_id   = "zebra_${var.env}_table"
  project    = "${var.project}"

  schema = "${file("bq-schema.json")}"

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

resource "google_bigquery_table" "zebra_table_view" {
  dataset_id = "${google_bigquery_dataset.zebra_dataset.dataset_id}"
  table_id   = "zebra_${var.env}_client_view"
  project    = "${var.project}"

  view {
    query          = "SELECT _id AS MessageID,_et AS EffectiveDate,_mt AS MessageType FROM `${var.project}.${google_bigquery_table.zebra_table.dataset_id}.${google_bigquery_table.zebra_table.table_id}` LIMIT 5"
    use_legacy_sql = false
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
