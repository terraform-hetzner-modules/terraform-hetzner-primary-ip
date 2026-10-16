module "ips" {
  source = "../.."
  labels = { environment = "example", managed_by = "terraform" }
  ips = {
    public_v4 = {
      name              = "web-v4"
      type              = "ipv4"
      location          = "fsn1"
      assignee_id       = null # The server below owns this association.
      assignee_type     = "server"
      auto_delete       = false
      delete_protection = true
      labels            = { family = "ipv4" }
    }
    public_v6 = { type = "ipv6", location = "fsn1", labels = { family = "ipv6" } }
    existing_server = {
      name              = "existing-server-v4"
      type              = "ipv4"
      location          = null # Mutually exclusive with assignee_id.
      assignee_id       = var.assignee_id
      assignee_type     = "server"
      auto_delete       = false
      delete_protection = true
      labels            = { assignment = "inline" }
    }
  }
}

resource "hcloud_server" "example" {
  name        = "primary-ip-example"
  server_type = "cx23"
  image       = "debian-13"
  location    = "fsn1"
  public_net {
    ipv4 = module.ips.ids.public_v4
    ipv6 = module.ips.ids.public_v6
  }
}
