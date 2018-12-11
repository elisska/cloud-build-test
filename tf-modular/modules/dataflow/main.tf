resource "google_storage_bucket" "zbra_dataflow_tmp" {
  name     = "${var.df_tmp_location}"
  location = "${var.region}"
  project  = "${var.project}"

  labels {
    env                 = "${var.env}"
    buownertechnical    = "ec5485"
    buownermanager      = "jhand"
    costcenter          = "36056"
    tier                = "development"
    projectorproduct    = "visibility_services"
    securityagentxxempt = "none"
  }
}

resource "google_dataflow_job" "zbra_dataflow_job" {
  name              = "${var.df_job_name}"
  zone              = "${var.zone}"
  template_gcs_path = "${var.df_tpl_location}"
  temp_gcs_location = "${google_storage_bucket.zbra_dataflow_tmp.url}"

  parameters {
    inputTopic      = "${var.df_param_input_topic}"
    outputTableSpec = "${var.df_param_output_table}"
    outputDeadletterTable = "${var.df_param_dead_letter_table}"
    javascriptTextTransformGcsPath = "${var.df_param_js_gsc_path}"
    javascriptTextTransformFunctionName = "${var.df_param_js_func_name}"
    javascriptTextTransformConfigurations = "${var.df_param_js_config}"
    firestoreProjectId  = "${var.df_param_firestore_project}"
    firestoreCollection = "${var.df_param_firestore_collection}"
  }

  lifecycle {
    ignore_changes = [
      "id",
      "project",
    ]
  }
}
