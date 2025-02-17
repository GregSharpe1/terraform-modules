variable "endpoints" {
  description = "A map of endpoints to create synthetic monitoring checks for."
  type        = map(object({
    frequency = optional(number)
    job       = optional(string)
    target    = string
    settings  = optional(
      map(
        object({
          http = map(any)
        }
      )
    )
  )
  }))
}
