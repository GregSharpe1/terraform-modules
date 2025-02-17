resource "grafana_rule_group" "rule_group" {
  for_each = {
    for alert_rule in local.alert_rule_groups : "${alert_rule.folder}-${alert_rule.alert_rule_group}" => alert_rule
  }

  name       = each.value.alert_rule_group
  folder_uid = var.folder != null ? var.folder.uid : data.grafana_folder.folder[each.value.folder].uid
  interval_seconds = coalesce(each.value.evaluation_time, local.default_rule_group_interval)

  dynamic "rule" {
    for_each = each.value.alert_rules
    iterator = rule

    content {
      name           = rule.value.name
      for            = try(rule.value.pending_time, local.default_rule_pending_time)
      condition      = try(rule.value.evaluator.type, local.default_evaluator_type)
      no_data_state  = try(rule.value.no_data_state, local.default_no_data_state)
      exec_err_state = try(rule.value.exec_err_state, local.default_exec_err_state)
      is_paused      = try(rule.value.is_paused, local.default_is_paused)

      annotations = rule.value.annotations

      labels = merge(
        {
          "CreatedBy" = "Terraform"
        },
        try(rule.value.labels, {}),
        tomap(var.additional_labels)
      )

      data {
        ref_id = "query"
        query_type = try(rule.value.instant, local.default_instant_query) ? "instant" : "range"
        relative_time_range {
          from = try(rule.value.wait_for_time, local.default_wait_for_time)
          to   = 0
        }
        datasource_uid = data.grafana_data_source.datasource[try(rule.value.datasource, local.default_datasource)].uid
        model = templatefile("${path.module}/models/query.json.tpl",
          {
            expr    = jsonencode(rule.value.expr)
            instant = try(rule.value.instant, local.default_instant_query)
            range   = try(rule.value.instant, local.default_instant_query) == true ? false : true
            queryType = jsonencode(try(rule.value.instant, local.default_instant_query) ? "instant" : "range")
          }
        )
      }

      dynamic "data" {
        // In order to use the reduce, we'll require ruducer.mode to be set.
        // If it's not set, we'll skip the reduce block.
        for_each = can(rule.value.reducer.mode) || can(rule.value.reducer.function) ? [1] : []

        content {
          ref_id = "reduce"
          relative_time_range {
            from = 600
            to   = 0
          }
          datasource_uid = "-100"
          model = templatefile("${path.module}/models/reduce.json.tpl",
            {
              function         = try(rule.value.reducer.function, local.default_reducer_function)
              mode             = try(rule.value.reducer.mode, local.default_reducer_mode)
              replaceWithValue = try(rule.value.reducer.replaceWithValue, local.default_reducer_replaceWithValue)
            }
          )
        }
      }


      data {
        ref_id = try(rule.value.evaluator.type, local.default_evaluator_type)
        relative_time_range {
          from = 600
          to   = 0
        }
        datasource_uid = "-100"
        model = templatefile("${path.module}/models/${try(rule.value.evaluator.type, local.default_evaluator_type)}.json.tpl",
          {
            // Setting refId is a bit of a hack, but if the required "mode" is not set when using "reduce", we'll assume there's no reduce and default to query.
            refId           = can(rule.value.reducer.mode) || can(rule.value.reducer.function) ? "reduce" : "query"
            expression      = try(rule.value.evaluator.expression, local.default_rule_type)
            expression_to   = try(rule.value.evaluator.to, local.default_rule_upped_range)
            expression_from = try(rule.value.evaluator.from, local.default_rule_lower_range)
          }
        )
      }

      dynamic "notification_settings" {
        for_each = can(rule.value.contact_point) ? [1] : []

        content {
          contact_point = rule.value.contact_point.name

          group_by = try(rule.value.contact_point.group_by, ["..."])
        }
      }
    }
  }
}
