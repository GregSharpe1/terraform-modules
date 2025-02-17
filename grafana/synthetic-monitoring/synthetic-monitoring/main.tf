# This module's intent is to create synthetic monitoring checks for Grafana Cloud, based upon a map of endpoints passed in. The module should also calculate the
# total usage of the different checks against the amount of free evaluators granted.

# Usage:
# module "synthetic_monitoring" {
#  source = "./modules/synthetic-monitoring"
#
#  endpoints = {
#    "faw_cymru" = {
#      "frequency" = 300000,
#      "job" = "http",
#      "target" = "https://faw.cymru",
#      "probe_locations" = [
#        data.grafana_synthetic_monitoring_probes.grafana_probe_locations.probes.London,
#        data.grafana_synthetic_monitoring_probes.grafana_probe_locations.probes.Ireland
#      ]
#      "settings" = {
#        "http" = {}
#      }
#    },
#    }
#  }
#
#  Notes:
#  * Only allows the creation of checks within the London area,
#  if needed this can be expanded to include other locations.
#  Although, this would require the "free_evaliuators" calculation to be
#  tweaked to multiply by the number of locations.

resource "grafana_synthetic_monitoring_check" "synthetic_monitoring_checks" {
  for_each = var.endpoints

  enabled   = true
  frequency = try(each.value.frequency, 300000) # Default to 5 minutes
  job       = try(each.value.job, "http")      # Default to http
  target    = each.value.target

  probes = try(each.value.probe_locations, [data.grafana_synthetic_monitoring_probes.grafana_probe_locations.probes.London]) # Default to all probes

  # Default to http settings
  settings {
    dynamic "http" {
      for_each = try(each.value.settings.http, [{}]) # Default to an empty block if missing
      content {
        # Add additional HTTP settings here if needed
      }
    }
  }
}
