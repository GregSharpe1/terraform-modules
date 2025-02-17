// Previously this module has been under the assumption that the folder will already exist.
//
// In the case of tf-grafana-base-alerts using this module, the module is creating the folder and then passing the uid to the module to force a dependency.
// Implemented within the tf-grafana-alerting is logic for this use case, which ignores what's in the folder field on the alerts yaml,
// and instead overrides it with the folder passed in here. Use this with caution.
variable "folder" {
  description = "Folder Name"
  type        = any
  default     = null
}

variable "alert_rule_groups" {
  description = "Alerts"
  type        = any
}

variable "additional_labels" {
  description = "Additional labels to add to all rules"
  type        = map(string)
  default     = {}
}
