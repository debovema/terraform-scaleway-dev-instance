# Scaleway cloud-init demo using Terraform

## Usage

1. Create your SSH key pair and [add it in your authorized keys](https://console.scaleway.com/account/credentials)

```
ssh-keygen -t rsa -b 4096 -q -C 'scaleway' -N '' -f ~/.ssh/scaleway
```

2. [Retrieve your organization and API token](https://console.scaleway.com/account/credentials) and export them:

```
export SCW_ACCESS_KEY=<REDACTED>
export SCW_SECRET_KEY=<REDACTED>
export SCW_DEFAULT_ORGANIZATION_ID=<REDACTED>
```

3. Initialize Terraform
```
terraform init
```

4. Apply default plan
```
terraform apply
```

5. SSH to the (first) created host
```
ssh -i ~/.ssh/scaleway root@$(terraform output --json | jq -r '.public_ips.value[0]')
```
