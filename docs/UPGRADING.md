# Maintenance and upgrade guide

This module starts with Terraform >= 1.7 and `hetznercloud/hcloud ~> 1.70`.
The test matrix covers Terraform 1.7.5/1.16.6 and OpenTofu 1.8.8/1.13.1.
These are module compatibility tests; older engines are not necessarily in the provider's own supported test matrix.

## Before upgrading

Back up your root configuration's state and commit its dependency lock file. Update the module version,
run `terraform init -upgrade` (or `tofu init -upgrade`), and review the plan before applying it.
Child module lock files do not constrain a consuming root configuration.
Keep caller-supplied map keys stable to retain resource addresses.
Unknown object properties may be discarded by Terraform's object conversion; check input property names.

## Checks

Run `terraform init -backend=false`, `terraform validate`, and `terraform test` (or equivalent `tofu`
commands). Initialize and validate each example and submodule separately. Tests use mock providers;
no cloud credentials are needed and no real infrastructure is created.
Before release, check creation, a second no-change plan, updates, and teardown in a disposable Hetzner
project. Mocks do not verify live API behavior, quotas, or capacity.

## Provider coverage maintenance

Formr generates the [schema report](SCHEMA.md). With the module initialized,
run `formr schema . -o docs/SCHEMA.md` and `formr check . --report docs/SCHEMA.md`.
Use the same engine and provider selections recorded in the report's provenance.
The default policy checks inventory completeness and unresolved analysis. Strict interface coverage
and exception annotations are not yet implemented, so a passing check does not approve omitted fields.
Provider configuration belongs in the consuming root configuration; IDs and other computed attributes
are provider-managed rather than creation inputs.

Regenerate README inputs/outputs with `terraform-docs -c .github/linters/.terraform-docs.yml .`.

## Primary IP lifecycle

The resource map exports supported attributes, excluding the obsolete `datacenter` field. All supported resource inputs are exposed; the deprecated
`datacenter` input is omitted because hcloud 1.70 rejects it. Use `location` instead.
`auto_delete` defaults to false and `delete_protection` to true. The caller can override both per IP.
A configured assignee ID defaults its assignee type to `server`; otherwise the type remains caller-specified
or null. The provider enforces location/assignee exclusivity. Coordinate changes to existing server IPs
with Hetzner's power-state and assignment constraints during live integration tests.

Formr currently marks `datacenter` as exported when tracing the resource collection through the output
comprehension. The output explicitly selects supported fields and excludes `datacenter`; that report entry
is a conservative dependency trace, not a declaration of the output object's fields.
