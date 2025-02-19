locals {
  total_monthly_executions = 100000
  total_number_checks      = max(length(var.endpoints), 1)  # Prevent division by zero
  number_days_in_month     = 31  # Months less than 31 days will have "spare" executions
  number_minutes_in_day    = 60 * 24
  rounding_factor_minutes  = 5   # Round to nearest 5 minutes

  executions_per_check     = local.total_monthly_executions / local.total_number_checks
  executions_per_day       = local.executions_per_check / local.number_days_in_month
  execution_interval_raw   = local.number_minutes_in_day / local.executions_per_day

  # Ensure execution_interval is at least 1 minute before rounding
  execution_interval       = max(local.execution_interval_raw, 1)

  # Round to the nearest rounding_factor_minutes (5 minutes by default)
  execution_interval_rounded = max(
    ceil(local.execution_interval / local.rounding_factor_minutes) * local.rounding_factor_minutes,
    local.rounding_factor_minutes  # Ensure we never round below the rounding factor
  )

  # Convert to milliseconds
  recommended_interval_ms  = local.execution_interval_rounded * 60 * 1000
}

output "executions_per_check" {
  value = local.executions_per_check
}

output "executions_per_day" {
  value = local.executions_per_day
}

output "execution_interval_minutes" {
  value       = local.execution_interval
  description = "Execution frequency in minutes before rounding (ensured min 1 minute)"
}

output "rounded_interval_minutes" {
  value       = local.execution_interval_rounded
  description = "Execution frequency rounded to nearest 5 minutes (ensured min 5 minutes)"
}

output "recommended_interval_ms" {
  value       = local.recommended_interval_ms
  description = "Execution interval in milliseconds"
}
