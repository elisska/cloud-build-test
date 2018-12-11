# Project common variables
variable "project" {
  type        = "string"
  description = "The name of the GCP project to create the resources in"
  default     = "es-s2dl-core-d"
}

variable "env" {
  type        = "string"
  description = "Uniq name to identify resources in GCP"
  default     = "dev"
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

# Module specific variables
variable "app_name" {
  type        = "string"
  description = "Application unique name"
}

variable "pubsub_topic_name" {
  type        = "string"
  description = "PubSub topic unique name"
}
