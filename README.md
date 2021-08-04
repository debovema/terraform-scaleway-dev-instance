# Scaleway development instances using Terraform and cloud-init

## Foreword

This Terraform module can be used to create cheap and disposable development machines with Scaleway cloud provider. For instance, these machines are well suited to be used with [Visual Studio Code SSH remote developement feature](https://code.visualstudio.com/docs/remote/ssh).

## Examples

* [Full-featured development instance on a Scaleway DEV1-S instance running Ubuntu 20.04](examples/ubuntu_dev1-s_full)

## Prerequisites

* Terraform 1.0+
* A [Scaleway project](https://console.scaleway.com/project/) (default project is fine but [creating a new one](https://www.scaleway.com/en/docs/scaleway-project/) is encouraged)
* Git, OpenSSH
* [jq](https://stedolan.github.io/jq/) (only for magic commands)

## Introduction

1. Define shell helper function to set Terraform variables

```
set_tfvar() { ( [ $(grep "$1" terraform.tfvars 2>/dev/null | wc -l) -gt 0 ] && sed -i -e "/^$1 /s/=.*$/= $(echo $2 | sed 's|\"|\\"|g' | sed 's|/|\\/|g')/" terraform.tfvars ) || echo "$1 = $2" >> terraform.tfvars }
```

> This shell function takes two arguments (the variable key and value) and put the *key = value* in the *terraform.tfvars* file regardless of the existence of the variable (create or replace behaviour)

2. Create your SSH key pair and [add the public key in authorized keys of your Scleway project in the Scaleway console](https://console.scaleway.com/project/credentials)

```
ssh-keygen -t rsa -b 4096 -q -C 'scaleway' -N '' -f ~/.ssh/scaleway
```

> if using an existing SSH key, it is assumed its name is *~/.ssh/scaleway*

Add the SSH key file in Terraform variables
```
set_tfvar ssh_key_file '"~/.ssh/scaleway"'
```

3. [Retrieve your project credentials](https://console.scaleway.com/project/credentials) and export them:

```
export SCW_DEFAULT_PROJECT_ID=<REDACTED>
export SCW_ACCESS_KEY=<REDACTED>
export SCW_SECRET_KEY=<REDACTED>
export SCW_DEFAULT_REGION=fr-par
export SCW_DEFAULT_ZONE=fr-par-1
```

## Usage

1. Clone this repository

```
git clone https://github.com/debovema/terraform-scaleway-dev-instance.git
cd terraform-scaleway-dev-instance
```

2. Initialize Terraform

```
terraform init
```

3. Define username

```
set_tfvar username '"developer"'
```

> Mind the double quotes

4. Select optional features

* [Oh My ZSH](https://ohmyz.sh/):
```
set_tfvar feature_omz true
```

* [Docker](https://www.docker.com/):
```
set_tfvar feature_docker true
```

* [nvm](https://github.com/nvm-sh/nvm) (for Node developments):
```
set_tfvar feature_nvm true
```

* [SDKMAN!](https://sdkman.io/) (for Java developments):
```
set_tfvar feature_sdkman true
```

5. Apply default plan
```
terraform apply
```

6. SSH to the (first) created host

```
eval `terraform output --json ssh_commands | jq -r ".[0]"`
```

> To display the SSH command used to connect:
> ```
> echo $(terraform output --json ssh_commands | jq -r ".[0]")
> ```