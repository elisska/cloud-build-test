output "bq_table_id" {
  value = "${var.project}:${var.bq_dataset_name}.${var.bq_dataset_table_name}"
}
