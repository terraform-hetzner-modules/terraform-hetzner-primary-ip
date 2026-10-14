output "ips" {
  description = "Supported IP resource attributes indexed by the caller's stable keys."
  value = {
    for key, ip in hcloud_primary_ip.current : key => {
      id                = ip.id
      name              = ip.name
      type              = ip.type
      location          = ip.location
      assignee_id       = ip.assignee_id
      assignee_type     = ip.assignee_type
      auto_delete       = ip.auto_delete
      delete_protection = ip.delete_protection
      labels            = ip.labels
      ip_address        = ip.ip_address
      ip_network        = ip.ip_network
    }
  }
}

output "ids" {
  description = "IP IDs indexed by the caller's stable keys."
  value       = { for key, ip in hcloud_primary_ip.current : key => ip.id }
}

output "names" {
  description = "IP names indexed by the caller's stable keys."
  value       = { for key, ip in hcloud_primary_ip.current : key => ip.name }
}

output "ip_addresses" {
  description = "IP addresses indexed by the caller's stable keys."
  value       = { for key, ip in hcloud_primary_ip.current : key => ip.ip_address }
}

output "ip_networks" {
  description = "IPv6 networks indexed by the caller's stable keys."
  value       = { for key, ip in hcloud_primary_ip.current : key => ip.ip_network }
}

output "labels" {
  description = "Merged labels indexed by the caller's stable keys."
  value       = { for key, ip in hcloud_primary_ip.current : key => ip.labels }
}
