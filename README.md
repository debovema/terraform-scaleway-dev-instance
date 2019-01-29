# Scaleway cloud-init demo using Terraform

## Usage

1. Retrieve your organization and token and export them:
```
export SCALEWAY_ORGANIZATION=<REDACTED>
export SCALEWAY_TOKEN=<REDACTED>
```

2. Initialize Terraform
```
terraform init
```

3. Apply default plan
```
terraform apply
```

4. SSH to the (first) created host
```
ssh -i ~/.ssh/scaleway root@$(terraform output --json | jq -r '.public_ips.value[0]')
```
