variable "node_count" {
  type    = string
  default = "1"
}

variable "node_name" {
  type    = string
  default = "cloud-init"
}

variable "server_image" {
  type    = string
  default = "ubuntu_focal"
  validation {
    condition     = can(regex("^(debian_|ubuntu_).*$", var.server_image))
    error_message = "The server_image value must start with ubuntu_ or debian_ (ubuntu_focal, debian_buster, ...)."
  }
}

variable "server_type" {
  type    = string
  default = "DEV1-S"
  validation {
    condition     = can(regex("^(DEV1-(S|M|L|XL))|(GP1-(XS|S|M|L|XL))$", var.server_type))
    error_message = "The server_type value must be a valid Scaleway instance type (DEV1-S, DEV1-M, DEV1-L, DEV1-XL, GP1-XS, GP1-S, GP1-M, GP1-L, GP1-XL)."
  }
}

variable "ssh_key_file" {
  type = string
}

variable "username" {
  type    = string
  default = "user"
}

# optional features
variable "feature_omz" {
  type        = bool
  description = "Whether to install Oh My ZSH or not"
  default     = false
}

variable "feature_k3s" {
  type        = bool
  description = "Whether to install K3S or not"
  default     = false
}

variable "feature_docker" {
  type        = bool
  description = "Whether to install Docker or not"
  default     = false
}

variable "feature_nvm" {
  type        = bool
  description = "Whether to install NVM or not"
  default     = false
}

variable "feature_sdkman" {
  type        = bool
  description = "Whether to install SDKMAN! or not"
  default     = false
}
