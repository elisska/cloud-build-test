resource "google_pubsub_topic" "zebra_raw_endpoint" {
  project = "${var.project}"
  name    = "zebra-raw-endpoint"

  depends_on = [
    "google_storage_bucket.zebra_dataflow_temp",
  ]
}
