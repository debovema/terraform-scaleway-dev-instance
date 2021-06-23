provider "scaleway" {
  # Provide configuration with environment variables, see https://www.terraform.io/docs/providers/scaleway/index.html#environment-variables
}

data "template_file" "userdata" {
  template = file("${path.module}/cloud-init-user-data")

  vars = {
    distrib  = var.docker_distrib
    user     = var.username
  }
}

resource "scaleway_instance_server" "node" {
  count = var.node_count

  name = "${var.node_name}-${count.index}"

  image               = var.server_image
  type                = var.server_type
  enable_dynamic_ip   = true

  # initialization sequence
  cloud_init = data.template_file.userdata.rendered

  connection {
    host = element(scaleway_instance_server.node.*.public_ip, count.index)
    user = var.username
    private_key = file(var.ssh_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "tail -f /var/log/cloud-init-output.log &",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done;",
    ]
  }
  provisioner "local-exec" {
    command = "sleep 80" # wait more than 1 minute for the instance to be rebooted
  }
}

resource "null_resource" "node" {
  count = var.node_count

  connection {
    host = element(scaleway_instance_server.node.*.public_ip, count.index)
    user = var.username
    private_key = file(var.ssh_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/www",
      "echo 'It works' > ~/www/index.html",
      "docker run --name http-nginx --restart=always -v ~/www:/usr/share/nginx/html:ro -p 80:80 -d nginx",
    ]
  }
}

