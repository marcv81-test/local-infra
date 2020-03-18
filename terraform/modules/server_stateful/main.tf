resource "libvirt_volume" "root" {
  name   = "${var.name}_root.img"
  source = var.root_image
  format = "qcow2"
}

resource "libvirt_volume" "data" {
  name   = "${var.name}_data.img"
  source = var.data_image
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "${var.name}_cloudinit.img"
  meta_data = templatefile(
    "${path.module}/meta-data",
    {
      hostname = "${var.name}.${var.network}"
    }
  )
  user_data = templatefile(
    "${path.module}/user-data",
    {
      public_key = trimspace(file("../../../resources/keys/id_ubuntu.pub"))
      data       = var.data_image != ""
    }
  )
}

resource "libvirt_domain" "server" {
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

  disk {
    volume_id = libvirt_volume.data.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  # Ubuntu cloud images fail to start without this.
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
