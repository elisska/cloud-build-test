module "spg_zpc_pubsub" {
  source = "../modules/pubsub"

  # Input arguments
  pubsub_topic_name = "spg-zpc-raw-endpoint"
}

module "spg_zpc_iam" {
  source = "../modules/iam"

  # Input arguments
  app_name          = "spg-zpc"
  pubsub_topic_name = "${module.spg_zpc_pubsub.pubsub_topic_name}"
}

module "spg_zpc_bigquery_dataset" {
  source = "../modules/bigquery_dataset"

  # Input arguments
  bq_dataset_name = "spg"
}

// Create 4 BQ tables: one per message type + 1 for errors
module "spg_zpc_bigquery_table_alerts" {
  source = "../modules/bigquery_table"

  # Input arguments
  app_name              = "spg"
  bq_dataset_name       = "${module.spg_zpc_bigquery_dataset.bq_dataset_id}"
  bq_dataset_table_name = "t_zpc_alerts"
}

module "spg_zpc_bigquery_table_discovery" {
  source = "../modules/bigquery_table"

  # Input arguments
  app_name              = "spg"
  bq_dataset_name       = "${module.spg_zpc_bigquery_dataset.bq_dataset_id}"
  bq_dataset_table_name = "t_zpc_discovery"
}

module "spg_zpc_bigquery_table_push" {
  source = "../modules/bigquery_table"

  # Input arguments
  app_name              = "spg"
  bq_dataset_name       = "${module.spg_zpc_bigquery_dataset.bq_dataset_id}"
  bq_dataset_table_name = "t_zpc_push"
}

module "spg_zpc_bigquery_table_error" {
  source = "../modules/bigquery_table"

  # Input arguments
  app_name              = "spg"
  bq_dataset_name       = "${module.spg_zpc_bigquery_dataset.bq_dataset_id}"
  bq_dataset_table_name = "t_zpc_error"
  time_partitioning_column = "timestamp"
}

//Create 3 dataflows, one per message type
module "spg_zpc_dataflow_alerts" {
  source = "../modules/dataflow"

  # Input arguments
  df_job_name           = "spg-zpc-alerts-pipeline"
  df_tmp_location       = "spg-zpc-df-alerts-temp"
  df_tpl_location       = "gs://es-s2dl-core-d-zbra-dataflow-templates/dataflow/pipelines/pubsub-to-bigquery/spg-zpc-pipeline-template"
  df_param_input_topic  = "${module.spg_zpc_pubsub.pubsub_topic_name}"
  df_param_output_table = "${module.spg_zpc_bigquery_table_alerts.bq_table_id}"
  df_param_dead_letter_table = "${module.spg_zpc_bigquery_table_error.bq_table_id}"
  df_param_js_gsc_path = "gs://es-s2dl-core-d-zbra-dataflow-templates/dataflow/pipelines/pubsub-to-bigquery/udf.template.js"
  df_param_js_func_name = "filterAndTransform"
  df_param_js_config = "{\"typ\": \"za\", \"mts\": [\"za\",\"zd\",\"zp\"]}"
  df_param_firestore_project    = "${var.project}"
  df_param_firestore_collection = "spg-zpc"
}

module "spg_zpc_dataflow_discovery" {
  source = "../modules/dataflow"

  # Input arguments
  df_job_name           = "spg-zpc-discovery-pipeline"
  df_tmp_location       = "spg-zpc-df-discovery-temp"
  df_tpl_location       = "gs://es-s2dl-core-d-zbra-dataflow-templates/dataflow/pipelines/pubsub-to-bigquery/spg-zpc-pipeline-template"
  df_param_input_topic  = "${module.spg_zpc_pubsub.pubsub_topic_name}"
  df_param_output_table = "${module.spg_zpc_bigquery_table_discovery.bq_table_id}"
  df_param_dead_letter_table = "${module.spg_zpc_bigquery_table_error.bq_table_id}"
  df_param_js_gsc_path = "gs://es-s2dl-core-d-zbra-dataflow-templates/dataflow/pipelines/pubsub-to-bigquery/udf.template.js"
  df_param_js_func_name = "filterAndTransform"
  df_param_js_config = "{\"typ\": \"zd\", \"mts\": [\"za\",\"zd\",\"zp\"]}"
  df_param_firestore_project    = "${var.project}"
  df_param_firestore_collection = "spg-zpc"
}

module "spg_zpc_dataflow_push" {
  source = "../modules/dataflow"

  # Input arguments
  df_job_name           = "spg-zpc-push-pipeline"
  df_tmp_location       = "spg-zpc-df-push-temp"
  df_tpl_location       = "gs://es-s2dl-core-d-zbra-dataflow-templates/dataflow/pipelines/pubsub-to-bigquery/spg-zpc-pipeline-template"
  df_param_input_topic  = "${module.spg_zpc_pubsub.pubsub_topic_name}"
  df_param_output_table = "${module.spg_zpc_bigquery_table_push.bq_table_id}"
  df_param_dead_letter_table = "${module.spg_zpc_bigquery_table_error.bq_table_id}"
  df_param_js_gsc_path = "gs://es-s2dl-core-d-zbra-dataflow-templates/dataflow/pipelines/pubsub-to-bigquery/udf.template.js"
  df_param_js_func_name = "filterAndTransform"
  df_param_js_config = "{\"typ\": \"zp\", \"mts\": [\"za\",\"zd\",\"zp\"]}"
  df_param_firestore_project    = "${var.project}"
  df_param_firestore_collection = "spg-zpc"
}
