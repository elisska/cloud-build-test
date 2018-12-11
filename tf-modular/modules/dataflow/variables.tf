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
variable "df_tmp_location" {
  type        = "string"
  description = "Path to Dataflow temporary location"
}

variable "df_tpl_location" {
  type        = "string"
  description = "Path to Dataflow job template"
}

variable "df_job_name" {
  type        = "string"
  description = "Dataflow pipeline unique name"
}

variable "df_param_input_topic" {
  type        = "string"
  description = "PubSub topic to subscribe (Dataflow job parameter)"
}

variable "df_param_output_table" {
  type        = "string"
  description = "BigQuery output table (Dataflow job parameter)"
}

variable "df_param_dead_letter_table" {
  type        = "string"
  description = "BQ deadletter table name"
}

variable "df_param_js_gsc_path" {
  type        = "string"
  description = "JS file path on gcs"
}

variable "df_param_js_func_name" {
  type        = "string"
  description = "JS function name"
}

variable "df_param_js_config" {
  type        = "string"
  description = "JS config"
}

variable "df_param_firestore_project" {
  type        = "string"
  description = "Project ID for Firestore document store (Dataflow job parameter)"
}

variable "df_param_firestore_collection" {
  type        = "string"
  description = "Firestore collection name for document store (Dataflow job parameter)"
}
