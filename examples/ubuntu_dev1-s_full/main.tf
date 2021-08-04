//--------------------------------------------------------------------
// Variables
variable "dev_ssh_key_file" { default = "~/.ssh/scaleway" }
variable "dev_username" { default = "developer" }

//--------------------------------------------------------------------
// Modules
module "dev" {
  source  = "app.terraform.io/scwdev/dev/scaleway"
  version = "0.0.2"

  feature_docker = "true"
  feature_nvm = "true"
  feature_omz = "true"
  feature_sdkman = "true"
  ssh_key_file = var.dev_ssh_key_file
  username = var.dev_username
}

//--------------------------------------------------------------------
// Outputs
output "public_ips" {
  value = module.dev.public_ips
}

output "ssh_commands" {
  value = module.dev.ssh_commands
}
