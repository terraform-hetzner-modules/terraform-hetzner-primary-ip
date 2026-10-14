module "ips" {
  source = "../.."
  ips = {
    public_v4 = { type = "ipv4", location = "fsn1" }
    public_v6 = { type = "ipv6", location = "fsn1" }
  }
}
