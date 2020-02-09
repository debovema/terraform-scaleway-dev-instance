output "public_ips" {
  value = scaleway_instance_server.node.*.public_ip
}

