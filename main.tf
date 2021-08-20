data "template_file" "userdata" {
  count    = var.node_count
  template = file("${path.module}/cloud-init-user-data")

  vars = {
    node_index      = count.index
    distrib         = regex("^ubuntu|debian", var.server_image)
    user            = var.username
    first_public_ip = scaleway_instance_ip.node_public_ip[0].address
    public_ip       = scaleway_instance_ip.node_public_ip[count.index].address

    feature_docker = var.feature_docker
    feature_k3s    = var.feature_k3s
    k3s_token      = var.feature_k3s ? random_password.k3s_token[0].result : ""
    feature_nvm    = var.feature_nvm
    feature_omz    = var.feature_omz
    feature_sdkman = var.feature_sdkman
  }
}

resource "random_password" "k3s_token" {
  count = var.feature_k3s ? 1 : 0

  length  = 32
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "scaleway_instance_ip" "node_public_ip" {
  count = var.node_count
}

resource "scaleway_instance_server" "node" {
  count = var.node_count

  name = "${var.node_name}-${count.index}"

  image = var.server_image
  type  = var.server_type
  ip_id = scaleway_instance_ip.node_public_ip[count.index].id

  # initialization sequence
  cloud_init = data.template_file.userdata[count.index].rendered
}

resource "null_resource" "wait_for_init" {
  count = var.node_count

  provisioner "remote-exec" {
    connection {
      host        = scaleway_instance_server.node[count.index].public_ip
      user        = "root"
      private_key = file(var.ssh_key_file)
    }

    inline = [
      "touch /var/log/cloud-init-output.log",
      "tail -f /var/log/cloud-init-output.log &",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done;",
    ]
  }

  provisioner "local-exec" {
    command = "sleep 80" # wait more than 1 minute for the instance to be rebooted
  }
}
