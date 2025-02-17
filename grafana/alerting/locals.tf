locals {
  alert_rule_groups = flatten([
    for each_team in var.alert_rule_groups : [
      for rule_group in each_team.rule_groups : {
        folder           = var.folder == null ? each_team.folder : var.folder.title
        alert_rule_group = rule_group.name
        evaluation_time  = lookup(rule_group, "evaluation_time", null)
        alert_rules      = rule_group.rules
      }
    ]
  ])

  # Default values for alert rules
  default_datasource          = "Prometheus"
  default_instant_query       = true
  default_rule_group_interval = 300
  default_wait_for_time       = 300
  default_evaluator_type      = "threshold"
  default_rule_type           = "lt"
  default_rule_lower_range    = 0
  default_rule_upped_range    = 1
  default_rule_pending_time   = "2m"
  default_no_data_state       = "OK"
  default_exec_err_state      = "OK"
  default_is_paused           = false

  default_reducer_mode             = ""     //empty value corresponds to strict mode
  default_reducer_function         = "last" // Verify
  default_reducer_replaceWithValue = 0

  datasource = distinct(
    flatten(
      [
        for alert in local.alert_rule_groups : [
          for rule in alert.alert_rules : try(rule.datasource, local.default_datasource)
        ]
      ]
    )
  )

  folder = toset(
    distinct(
      flatten(
        [
          for rule_group in local.alert_rule_groups : rule_group.folder
        ]
      )
    )
  )
}
