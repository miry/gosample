resource "libvirt_pool" "kube" {
  name = "kube"
  type = "dir"
  path = "/tmp/tf-pool-kube"
}

resource "libvirt_volume" "master" {
  name   = "kube_master"
  pool   = libvirt_pool.kube.name
  source = "http://ftp.tu-chemnitz.de/pub/linux/fedora/linux/releases/31/Cloud/x86_64/images/Fedora-Cloud-Base-31-1.9.x86_64.qcow2"
  format = "qcow2"
}

data "template_file" "master_user_data" {
  template = file("${path.module}/data/master_user_data.tpl.yml")
  vars = {
    public_key = tls_private_key.kube.public_key_openssh
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/data/network_config.yml")
}

resource "libvirt_cloudinit_disk" "master_cloudinit" {
  name           = "cloudinit.iso"
  user_data      = data.template_file.master_user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = libvirt_pool.kube.name
}

resource "libvirt_domain" "master" {
  name   = "kube-master"
  memory = "2048"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.master_cloudinit.id

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.master.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "master_addresses" {
  value = join(",", libvirt_domain.master.network_interface[0].addresses)
}
