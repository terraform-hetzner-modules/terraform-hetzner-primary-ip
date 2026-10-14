<p align="center">
    <!-- terraform-hetzner-primary-ip -->
<img src="https://cdn.simpleicons.org/terraform/844FBA" alt="Terraform Logo" align="center" width="128">
<img src="https://avatars.githubusercontent.com/u/30047064?s=200&v=4" alt="Hetzner Logo" align="center" width="128">
    <h1 align="center">Hetzner Cloud</h1>
    <h2 align="center"><code>primary-ip</code></h2>
</p>

[![License](https://img.shields.io/github/license/terraform-hetzner-modules/terraform-hetzner-primary-ip?label=License)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-_>=_1.7-brightgreen?logo=terraform&logoColor=623CE4)][terraform]
[![Opentofu](https://img.shields.io/badge/OpenTofu-_>=_1.8-brightgreen?logo=opentofu)][opentofu]
[![CI Status](https://github.com/terraform-hetzner-modules/terraform-hetzner-primary-ip/actions/workflows/testing.yaml/badge.svg)](https://github.com/terraform-hetzner-modules/terraform-hetzner-primary-ip/blob/main/.github/workflows/testing.yaml)
[![GitHub Release](https://img.shields.io/github/v/release/terraform-hetzner-modules/terraform-hetzner-primary-ip?label=Release)][github_releases]
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/terraform-hetzner-modules/terraform-hetzner-primary-ip?label=Commits)][github_commits]
[![Renovate](https://img.shields.io/badge/Renovate-enabled-brightgreen?logo=renovate&logoColor=1A1F6C)][renovate]
[![Pre-Commit](https://img.shields.io/badge/PreCommit-enabled-brightgreen?logo=precommit&logoColor=FAB040)][pre-commit]

A [Terraform module][module] to manage a collection of Primary IPs in [Hetzner Cloud][hetzner].

## ✨ TL;DR

```hcl
module "ips" {
  source = "terraform-hetzner-modules/primary-ip/hetzner"

  labels = { managed_by = "terraform" }
  ips = {
    public_v4 = { type = "ipv4", location = "fsn1" }
    public_v6 = { type = "ipv6", location = "fsn1", name = "web-v6" }
  }
}
```

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

## Compatibility and examples

Requires Terraform >= 1.7 (OpenTofu >= 1.8 tested) and hcloud ~> 1.70.
See [basic](examples/basic) and [full](examples/full) examples; configure credentials through `HCLOUD_TOKEN`.
The generated [schema report](docs/SCHEMA.md) records provider fields and module mappings.
See the [maintenance and upgrade guide](docs/UPGRADING.md) for validation and coverage checks.
Run `terraform init -backend=false`, `terraform validate`, and `terraform test`
for credential-free validation and mocked tests.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | ~> 1.70 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_ips"></a> [ips](#input\_ips) | Primary IPs keyed by stable identifiers. Names default to map keys. Configure exactly one of location or assignee\_id per IP; assignee\_type defaults to server when assigning. | ```map(object({ name = optional(string) type = string location = optional(string) assignee_id = optional(number) assignee_type = optional(string) auto_delete = optional(bool, false) delete_protection = optional(bool, true) labels = optional(map(string), {}) }))``` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels shared by all IPs. Per-IP labels take precedence. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ids"></a> [ids](#output\_ids) | IP IDs indexed by the caller's stable keys. |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | IP addresses indexed by the caller's stable keys. |
| <a name="output_ip_networks"></a> [ip\_networks](#output\_ip\_networks) | IPv6 networks indexed by the caller's stable keys. |
| <a name="output_ips"></a> [ips](#output\_ips) | Supported IP resource attributes indexed by the caller's stable keys. |
| <a name="output_labels"></a> [labels](#output\_labels) | Merged labels indexed by the caller's stable keys. |
| <a name="output_names"></a> [names](#output\_names) | IP names indexed by the caller's stable keys. |
<!-- END_TF_DOCS -->

### 🔃 Contributing

Refer to our [documentation for contributors][contributing] for contributing guidelines, commit message
formats and versioning tips.

### 📥 Maintainers

This project is owned and maintained by [Terraform Hetzner Modules][org]. Refer to the [`AUTHORS`][authors] or [`CODEOWNERS`][owners]
for more information. You may also use the linked contact details to reach out directly.

### ©️ Copyright

- _Assets provided by:_ **[HashiCorp][hashicorp]**
- _Sources provided by:_ **[Terraform Hetzner Modules][org]** under the **[MIT License][license]**

<!-- INTERNAL REFERENCES -->

<!-- Project references -->

<!-- File references -->

[license]: LICENSE
[contributing]: docs/CONTRIBUTING.md
[authors]: .github/AUTHORS
[owners]: .github/CODEOWNERS

<!-- General links -->

[org]: https://github.com/terraform-hetzner-modules
[terraform]: https://terraform.io
[opentofu]: https://opentofu.org/
[hashicorp]: https://www.hashicorp.com/
[hetzner]: https://hetzner.com
[github_releases]: https://github.com/terraform-hetzner-modules/terraform-hetzner-primary-ip/releases
[github_commits]: https://github.com/terraform-hetzner-modules/terraform-hetzner-primary-ip/commits/main/

<!-- Third-party -->

[module]: https://registry.terraform.io/modules/terraform-hetzner-modules/primary-ip/hetzner/latest
[renovate]: https://renovatebot.com/
[pre-commit]: https://pre-commit.com/
