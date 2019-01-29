variable "node_count" {
  type    = "string"
  default = "1"
}

variable "node_name" {
  type    = "string"
  default = "cloud-init"
}

variable "server_arch" {
  type    = "string"
  default = "x86_64"
}

variable "server_image" {
  type    = "string"
  default = "Ubuntu Bionic"
}

variable "server_type" {
  type    = "string"
  default = "START1-S"
}
