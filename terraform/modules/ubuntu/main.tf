resource "libvirt_volume" "base" {
  name   = "${var.name}_base.img"
  source = "../../resources/images/eoan-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "resized" {
  name           = "${var.name}_resized.img"
  base_volume_id = libvirt_volume.base.id
  format         = "qcow2"
  size           = var.disk_size
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "${var.name}_cloudinit.img"

  user_data = <<EOF
#cloud-config
users:
  - name: ubuntu
    ssh-authorized-keys:
      - ${file("../../resources/keys/id_ubuntu.pub")}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
EOF
}

resource "libvirt_domain" "ubuntu" {
  name      = var.name
  vcpu      = var.cpu
  memory    = var.memory
  autostart = true

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.resized.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  # Ubuntu cloud images fail to start without this.
  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
