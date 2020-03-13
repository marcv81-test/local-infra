resource "libvirt_volume" "root" {
  name   = "${var.name}_root.img"
  source = "../../resources/images/packer.img"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "${var.name}_cloudinit.img"
  meta_data = templatefile(
    "${path.module}/meta-data.cfg",
    {
      hostname = "${var.name}.${var.network}"
    }
  )
  user_data = templatefile(
    "${path.module}/user-data.cfg",
    {
      public_key = file("../../resources/keys/id_ubuntu.pub")
    }
  )
}

resource "libvirt_domain" "ubuntu" {
  name      = var.name
  vcpu      = var.cpu
  memory    = var.memory
  autostart = true

  network_interface {
    network_name   = var.network
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.root.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  # Ubuntu cloud images fail to start without this.
  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
