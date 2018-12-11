resource "google_service_account" "zbra_pubsub_ingestion" {
  project      = "${var.project}"
  account_id   = "${var.app_name}-publisher"
  display_name = "Zebra PubSub ${var.app_name} ingestion service account"
}

resource "google_service_account_key" "zbra_pubsub_ingestion_key" {
  service_account_id = "${google_service_account.zbra_pubsub_ingestion.name}"
}

resource "local_file" "zbra_pubsub_ingestion_key" {
  content  = "${base64decode(google_service_account_key.zbra_pubsub_ingestion_key.private_key)}"
  filename = "${path.root}/${var.app_name}-pubsub-ingestion-key.json"
}

resource "google_pubsub_topic_iam_member" "zbra_raw_endpoint" {
  project = "${var.project}"
  topic   = "${var.pubsub_topic_name}"
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.zbra_pubsub_ingestion.email}"
}
