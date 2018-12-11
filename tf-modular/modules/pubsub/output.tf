output "pubsub_topic_name" {
  value = "projects/${var.project}/topics/${google_pubsub_topic.zbra_raw_endpoint.name}"
}
