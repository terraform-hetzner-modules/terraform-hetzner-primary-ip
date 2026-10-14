mock_provider "hcloud" {
  mock_resource "hcloud_primary_ip" { defaults = { id = 42, ip_address = "192.0.2.1", ip_network = "2001:db8::/64" } }
}

run "empty_collection" {
  command = apply
  assert {
    condition     = length(output.ips) == 0 && length(output.ids) == 0
    error_message = "An empty IP map must create no resources."
  }
}

run "multiple_ips_and_label_overrides" {
  command = apply
  variables {
    labels = { environment = "shared", managed_by = "terraform" }
    ips = {
      ipv4 = { type = "ipv4", location = "fsn1" }
      ipv6 = { type = "ipv6", location = "hel1", name = "public-v6", labels = { environment = "production" }, delete_protection = false }
    }
  }
  assert {
    condition     = keys(output.ids) == ["ipv4", "ipv6"] && output.names.ipv4 == "ipv4" && output.names.ipv6 == "public-v6"
    error_message = "Multiple IPs must retain caller keys and name overrides."
  }
  assert {
    condition     = output.labels.ipv6.environment == "production" && output.labels.ipv6.managed_by == "terraform" && output.labels.ipv4.environment == "shared"
    error_message = "Per-IP labels must override shared defaults without losing other labels."
  }
  assert {
    condition     = output.ips.ipv4.delete_protection && !output.ips.ipv6.delete_protection && output.ips.ipv6.location == "hel1" && output.ip_addresses.ipv4 == "192.0.2.1" && output.ip_networks.ipv6 == "2001:db8::/64"
    error_message = "Protection, location, addresses, and IPv6 networks must be preserved."
  }
}

run "retain_and_rename_one_ip" {
  command = apply
  variables { ips = { ipv4 = { type = "ipv4", location = "fsn1", name = "renamed" } } }
  assert {
    condition     = keys(output.ips) == ["ipv4"] && output.names.ipv4 == "renamed"
    error_message = "Removing other IPs and renaming an IP must preserve its caller key."
  }
}

run "reject_invalid_type" {
  command = plan
  variables { ips = { invalid = { type = "ipv5", location = "fsn1" } } }
  expect_failures = [var.ips]
}

run "reject_missing_location_and_server" {
  command = plan
  variables { ips = { invalid = { type = "ipv4" } } }
  expect_failures = [var.ips]
}

run "existing_server_assignment" {
  command = apply
  variables {
    ips = {
      existing = { type = "ipv4", assignee_id = 123, auto_delete = true }
      explicit = { type = "ipv6", assignee_id = 456, assignee_type = "server" }
    }
  }
  assert {
    condition     = output.ips.existing.assignee_id == 123 && output.ips.existing.assignee_type == "server" && output.ips.existing.auto_delete && !output.ips.explicit.auto_delete
    error_message = "Assignee IDs, type defaults/overrides, and auto-delete settings must reach the provider."
  }
}

run "reject_location_with_assignee" {
  command = plan
  variables { ips = { invalid = { type = "ipv4", location = "fsn1", assignee_id = 123 } } }
  expect_failures = [var.ips]
}
