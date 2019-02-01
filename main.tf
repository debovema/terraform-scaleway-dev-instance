data "scaleway_image" "image" {
  count        = "${var.node_count > 0 ? 1 : 0}"

  architecture = "${var.server_arch}"
  name         = "${var.server_image}"
}

resource "scaleway_server" "node" {
  count               = "${var.node_count}"

  name                = "${var.node_name}-${count.index}"

  image               = "${data.scaleway_image.image.id}"
  type                = "${var.server_type}"
  dynamic_ip_required = true
  boot_type           = "local"

  # initialization sequence
  cloudinit           = "${data.template_file.userdata.rendered}"
  provisioner "remote-exec" {
    inline = [
      "tail -f /var/log/cloud-init-output.log &",
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 10; done;"
    ]
  }
  provisioner "local-exec" {
    command = "sleep 80" # wait more than 1 minute for the instance to be rebooted
  }

}

data "template_file" "userdata" {
  template = "${file("${path.module}/cloud-init-user-data")}"

  vars {
    codename = "${var.docker_distrib_codename}"
    distrib  = "${var.docker_distrib}"
    user     = "${var.username}"
  }
}

resource "null_resource" "node" {
  count = "${var.node_count}"

  connection {
    host = "${element(scaleway_server.node.*.public_ip, count.index)}"
    user = "${var.username}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/www",
      "echo 'It works' > ~/www/index.html",
      "docker run --name http-nginx --restart=always -v ~/www:/usr/share/nginx/html:ro -p 80:80 -d nginx"
    ]
  }
}
