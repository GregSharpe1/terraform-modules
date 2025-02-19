variable "endpoints" {
  description = "A map of endpoints to create synthetic monitoring checks for."
  type = map(object({
    frequency = optional(number, 300000) # Default frequency to 5minutes if not provided
    job       = optional(string, "http") # Default job type
    target    = string
    settings  = optional(map(object({
      http = map(any)
    })), {}) # Default empty map if not provided
  }))
}
