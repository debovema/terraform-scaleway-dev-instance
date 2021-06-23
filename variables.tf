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
}

variable "server_type" {
  type    = string
  default = "DEV1-S"
}

variable "ssh_key_file" {
  type    = string
  default = "~/.ssh/scaleway"
}

variable "username" {
  type    = string
  default = "user"
}

variable "docker_distrib" {
  type    = string
  default = "ubuntu"
}
