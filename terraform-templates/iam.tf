resource "google_service_account" "zebra_pubsub_ingestion" {
  project      = "${var.project}"
  account_id   = "zebra-pubsub-ingestion"
  display_name = "Zebra PubSub Ingestion service account"
}

resource "google_service_account_key" "zebra_pubsub_ingestion_key" {
  service_account_id = "${google_service_account.zebra_pubsub_ingestion.name}"
}

resource "local_file" "zebra_pubsub_ingestion_key" {
  content  = "${base64decode(google_service_account_key.zebra_pubsub_ingestion_key.private_key)}"
  filename = "${path.module}/zebra-pubsub-ingestion-key.json"
}

resource "google_project_iam_member" "zebra_message_publisher" {
  project = "${var.project}"
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.zebra_pubsub_ingestion.email}"
}
