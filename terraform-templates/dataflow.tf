resource "google_dataflow_job" "zebra_dataflow_job" {
  name              = "zebra-dataflow-job"
  zone              = "${var.zone}"
  template_gcs_path = "${var.dataflow_template_location}"
  temp_gcs_location = "${google_storage_bucket.zebra_dataflow_temp.url}"

  parameters {
    inputTopic      = "projects/${var.project}/topics/${google_pubsub_topic.zebra_raw_endpoint.name}"
    outputTableSpec = "${var.project}:${google_bigquery_table.zebra_table.dataset_id}.${google_bigquery_table.zebra_table.table_id}"
  }

  depends_on = [
    "google_bigquery_table.zebra_table",
    "google_pubsub_topic.zebra_raw_endpoint",
  ]
}
