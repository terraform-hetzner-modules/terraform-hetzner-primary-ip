variable "ips" {
  description = "Primary IPs keyed by stable identifiers. Names default to map keys. Configure exactly one of location or assignee_id per IP; assignee_type defaults to server when assigning."
  type = map(object({
    name              = optional(string)
    type              = string
    location          = optional(string)
    assignee_id       = optional(number)
    assignee_type     = optional(string)
    auto_delete       = optional(bool, false)
    delete_protection = optional(bool, true)
    labels            = optional(map(string), {})
  }))
  default  = {}
  nullable = false

  validation {
    condition     = alltrue([for ip in values(var.ips) : contains(["ipv4", "ipv6"], ip.type)])
    error_message = "Each Primary IP type must be ipv4 or ipv6."
  }

  validation {
    condition     = alltrue([for ip in values(var.ips) : (ip.location != null) != (ip.assignee_id != null)])
    error_message = "Each Primary IP requires exactly one of location or assignee_id."
  }
}

variable "labels" {
  description = "Labels shared by all IPs. Per-IP labels take precedence."
  type        = map(string)
  default     = {}
  nullable    = false
}
