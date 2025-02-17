variable "endpoints" {
  description = "A map of endpoints to create synthetic monitoring checks for."
  type        = map(object({
    frequency = number
    job       = string
    target    = string
    # TODO (gsharpe) - Add support for other job types and settings. (User Journey type checks)
    # settings  = map(object({
    #   http = map(any)
    # }))
  }))
}
