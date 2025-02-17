output "grafna_probes_locations" {
  value = data.grafana_synthetic_monitoring_probes.grafana_probe_locations.probes
}

# According to Grafana Synthetic Monitoring pricing, the free tier includes 100,000 executions per month. This output should calculate the total usage of the different checks against the amount of free evaluators granted.

locals {
  total_frequency_seconds = sum([for k, v in var.endpoints : v.frequency]) / 1000
  seconds_per_month       = 30 * 24 * 60 * 60
  total_checks_allowed    = 100000
  total_possible_checks   = local.seconds_per_month / local.total_frequency_seconds
  within_limit            = local.total_possible_checks <= local.total_checks_allowed
}

output "probe_total_frequency" {
  value = sum([for k, v in var.endpoints : v.frequency])
}

output "total_possible_checks" {
  value = local.total_possible_checks
}

output "within_grafana_limit" {
  value = local.within_limit
}
