# Full primary ip example

The independently allocated IPv4 and IPv6 addresses are passed to a newly created server.
The `existing_server` entry demonstrates the alternative inline `assignee_id` configuration.
Supply `assignee_id` for an existing powered-off server without a Primary IPv4 in the same project.
Its public-network association must not be managed by another Terraform resource.

`location` and `assignee_id` are mutually exclusive. The example leaves `auto_delete = false` so IPs
remain independent of server deletion. Review deletion protection before removing the addresses.

## Running the example

Export `HCLOUD_TOKEN`, supply the inputs described in `variables.tf`, then run:

```shell
terraform init
terraform plan
terraform apply
```

This creates real infrastructure. Review the plan and any deletion protection before cleanup.
See the [module README](../../README.md) for provider configuration and input descriptions.
