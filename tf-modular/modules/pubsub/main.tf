resource "google_pubsub_topic" "zbra_raw_endpoint" {
  project = "${var.project}"
  name    = "${var.pubsub_topic_name}"
}
