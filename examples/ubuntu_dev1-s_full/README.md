# Example : Full-featured development instance on a Scaleway DEV1-S instance running Ubuntu 20.04

Read the [module documentation](../../README.md) for further explanation.

## Prerequisites

* Terraform 1.0+
* A [Scaleway project](https://console.scaleway.com/project/) (default project is fine but [creating a new one](https://www.scaleway.com/en/docs/scaleway-project/) is encouraged)
* curl, OpenSSH
* [jq](https://stedolan.github.io/jq/) (only for magic commands)

## Introduction

1. Create your SSH key pair and [add the public key in authorized keys of your Scleway project in the Scaleway console](https://console.scaleway.com/project/credentials)

```
ssh-keygen -t rsa -b 4096 -q -C 'scaleway' -N '' -f ~/.ssh/scaleway
```

> if using an existing SSH key, it is assumed its name is *~/.ssh/scaleway*

2. [Retrieve your project credentials](https://console.scaleway.com/project/credentials) and export them:

```
export SCW_DEFAULT_PROJECT_ID=<REDACTED>
export SCW_ACCESS_KEY=<REDACTED>
export SCW_SECRET_KEY=<REDACTED>
export SCW_DEFAULT_REGION=fr-par
export SCW_DEFAULT_ZONE=fr-par-1
```

## Usage

1. Retrieve the (root) Terraform module of this example

```
mkdir ubuntu_dev1-s_full
cd ubuntu_dev1-s_full
curl -fsSL -O https://raw.githubusercontent.com/debovema/terraform-scaleway-dev-instance/main/examples/ubuntu_dev1-s_full/main.tf
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
eval `terraform output --json ssh_commands | jq -r ".[0]"`
```

> To display the SSH command used to connect:
> ```
> echo $(terraform output --json ssh_commands | jq -r ".[0]")
> ```