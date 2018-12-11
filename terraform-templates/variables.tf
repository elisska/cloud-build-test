variable "project" {
  type        = "string"
  description = "The name of the GCP project to create the resources in"
}

variable "env" {
  type        = "string"
  description = "Uniq name to identify resources in GCP"
}

variable "region" {
  type        = "string"
  description = "Google Cloud Region to deploy the stack"
  default     = "us-central1"
}

variable "zone" {
  type        = "string"
  description = "Google Cloud Zone to deploy the stack"
  default     = "us-central1-c"
}

variable "dataflow_template_location" {
  type        = "string"
  description = "Path to public Dataflow template"
  default     = "gs://dataflow-templates/latest/PubSub_to_BigQuery"
}
