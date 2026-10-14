module "ips" {
  source = "../.."
  labels = { environment = "example", managed_by = "terraform" }
  ips = {
    public_v4 = { type = "ipv4", location = "fsn1", name = "web-v4" }
    public_v6 = { type = "ipv6", location = "fsn1", labels = { family = "ipv6" } }
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
