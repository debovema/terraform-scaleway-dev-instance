output "public_ips" {
  value = scaleway_instance_server.node.*.public_ip
}

output "ssh_commands" {
  value = [
    for ip in scaleway_instance_server.node.*.public_ip : "ssh -i ${var.ssh_key_file} ${var.username}@${ip}"
  ]
}
