data "grafana_folder" "folder" {
  for_each = var.folder == null ? local.folder : toset([])

  title = each.value
}

data "grafana_data_source" "datasource" {
  for_each = toset(local.datasource)

  name = each.value
}
