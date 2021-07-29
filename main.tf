provider "scaleway" {
  # Provide configuration with environment variables, see https://www.terraform.io/docs/providers/scaleway/index.html#environment-variables
}

data "template_file" "userdata" {
  template = file("${path.module}/cloud-init-user-data")

  vars = {
    distrib        = regex("^ubuntu|debian", var.server_image)
    user           = var.username
    feature_docker = var.feature_docker
    feature_nvm    = var.feature_nvm
    feature_omz    = var.feature_omz
    feature_sdkman = var.feature_sdkman
  }
}

resource "scaleway_instance_server" "node" {
  count = var.node_count

  name = "${var.node_name}-${count.index}"

  image             = var.server_image
  type              = var.server_type
  enable_dynamic_ip = true

  # initialization sequence
  cloud_init = data.template_file.userdata.rendered
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

resource "null_resource" "docker_test" {
  count = var.feature_docker && var.feature_docker_test ? var.node_count : 0

  provisioner "remote-exec" {
    connection {
      host        = element(scaleway_instance_server.node.*.public_ip, count.index)
      user        = var.username
      private_key = file(var.ssh_key_file)
    }

    inline = [
      "mkdir -p ~/www",
      "echo 'It works' > ~/www/index.html",
      "docker run --name http-nginx --restart=always -v ~/www:/usr/share/nginx/html:ro -p 80:80 -d nginx",
    ]
  }
}
