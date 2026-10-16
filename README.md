# Hetzner Primary IP Terraform module

Manage multiple IPv4 and IPv6 Primary IPs with shared labels and optional server assignments.

## Usage

Copy this configuration into `main.tf` and add the
[provider configuration](#provider-configuration) below in `versions.tf`.

```hcl
module "primary_ips" {
  source = "terraform-hetzner-modules/primary-ip/hetzner"

  ips = {
    web = { type = "ipv4", location = "fsn1" }
  }
}
```

The address remains independently allocated. Pass `module.primary_ips.ids.web` to a server
configuration in the same location when creating it.

## Provider configuration

Export your Hetzner API token as `HCLOUD_TOKEN`. Put the following in your calling root's `versions.tf`:

```hcl
terraform {
  required_version = ">= 1.7"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70"
    }
  }
}

provider "hcloud" {}
```

With both files in place, run `terraform init`, `terraform plan`, and `terraform apply`.
Credentials and provider configuration belong in the calling root.
Terraform >= 1.7 and OpenTofu >= 1.8 are supported.

## Examples

- [Basic](examples/basic): independent address allocation.
- [Full](examples/full): every IP setting, server creation, and assignment to an existing server.

## Managing multiple IPs

One invocation manages the entire `ips` map; an empty map creates no IPs.
Map keys are stable resource addresses and must be known during planning. Names default to these keys;
renaming an IP through `name` preserves its address. Per-IP labels override shared `labels`.
The `ids`, `names`, `ip_addresses`, `ip_networks`, and `labels` outputs use the same keys.
The `ips` output exposes the supported provider attributes, excluding the obsolete `datacenter` field. Both IPv4 and IPv6 are supported.
Deletion protection defaults to true and can be overridden for each IP.

## Assigning Primary IPs

For independently managed IPs, supply `location` and pass their IDs to the server's public network
configuration. The [full example](examples/full) creates a server using both IP families.
With our server module, use `networking = { ipv4 = module.ips.ids.public_v4, ipv6 = module.ips.ids.public_v6 }`.
The server and its Primary IPs must be in the same location and project; the IPs must be unassigned
when creating the server. See [Hetzner's server creation guide](https://docs.hetzner.com/cloud/servers/getting-started/creating-a-server/).

To assign directly to an existing server, supply `assignee_id` instead of `location`.
`assignee_type` defaults to `server` when an assignee ID is supplied. Server IDs may be computed;
only the IP map keys need to be known at plan time. The provider requires exactly one of `location`
or `assignee_id`. Avoid managing the same association through both an inline assignee and a server's
public network configuration.

`auto_delete` defaults to false so that deleting a server does not also delete an independently managed
IP. You can enable it per IP, but this allows the server's deletion to remove the IP outside its Terraform
resource lifecycle. Changing IP type or location replaces the IP.
The obsolete `datacenter` input is intentionally excluded; use `location`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| hcloud | ~> 1.70 |

## Providers

| Name | Version |
| ---- | ------- |
| hcloud | ~> 1.70 |

## Resources

| Name | Type |
| ---- | ---- |
| [hcloud_primary_ip.current](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/primary_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| ips | Primary IPs keyed by stable identifiers. Names default to map keys. Configure exactly one of location or assignee\_id per IP; assignee\_type defaults to server when assigning. | ```map(object({ name = optional(string) type = string location = optional(string) assignee_id = optional(number) assignee_type = optional(string) auto_delete = optional(bool, false) delete_protection = optional(bool, true) labels = optional(map(string), {}) }))``` | `{}` | no |
| labels | Labels shared by all IPs. Per-IP labels take precedence. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| ids | IP IDs indexed by the caller's stable keys. |
| ip\_addresses | IP addresses indexed by the caller's stable keys. |
| ip\_networks | IPv6 networks indexed by the caller's stable keys. |
| ips | Supported IP resource attributes indexed by the caller's stable keys. |
| labels | Merged labels indexed by the caller's stable keys. |
| names | IP names indexed by the caller's stable keys. |
<!-- END_TF_DOCS -->

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for local checks and contribution guidelines, and
[UPGRADING.md](docs/UPGRADING.md) for compatibility and live acceptance checks. The generated
[schema report](docs/SCHEMA.md) documents provider coverage and intentional omissions.

## Authors

Maintained by [Terraform Hetzner Modules](https://github.com/terraform-hetzner-modules).
See [AUTHORS](.github/AUTHORS) and [CODEOWNERS](.github/CODEOWNERS).

## License

MIT. See [LICENSE](LICENSE).
