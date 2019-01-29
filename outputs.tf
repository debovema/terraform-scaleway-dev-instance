output "public_ips" {
  value = "${scaleway_server.node.*.public_ip}"
}

