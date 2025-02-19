locals {
  total_monthly_executions = 100000
  total_number_checks      = length(var.endpoints)
  number_days_in_month     = 31  # Months less than 31 days will have "spare" executions
  number_minutes_in_day    = 60 * 24
  rounding_factor_minutes  = 5   # Round to nearest 5 minutes

  executions_per_check     = local.total_monthly_executions / local.total_number_checks
  executions_per_day       = local.executions_per_check / local.number_days_in_month
  execution_interval       = local.number_minutes_in_day / local.executions_per_day

  # Workaround to round execution_interval to the nearest rounding_factor_minutes
  execution_interval_rounded = floor((local.execution_interval + (local.rounding_factor_minutes / 2)) / local.rounding_factor_minutes) * local.rounding_factor_minutes

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
  description = "Suggested execution frequency in minutes before rounding"
}

output "rounded_interval_minutes" {
  value       = local.execution_interval_rounded
  description = "Recommended execution interval rounded to the nearest 5 minutes"
}

output "recommended_interval_ms" {
  value       = local.recommended_interval_ms
  description = "Recommended execution interval in milliseconds"
}
