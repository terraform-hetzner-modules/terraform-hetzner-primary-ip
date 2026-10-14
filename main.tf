resource "hcloud_primary_ip" "current" {
  for_each = var.ips

  name              = coalesce(each.value.name, each.key)
  type              = each.value.type
  location          = each.value.location
  assignee_id       = each.value.assignee_id
  assignee_type     = each.value.assignee_id == null ? each.value.assignee_type : coalesce(each.value.assignee_type, "server")
  auto_delete       = each.value.auto_delete
  delete_protection = each.value.delete_protection
  labels            = merge(var.labels, each.value.labels)
}
