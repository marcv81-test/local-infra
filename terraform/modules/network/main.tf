resource "libvirt_network" "network" {
  name      = var.name
  domain    = var.name
  addresses = [var.prefix]
  dns {
    enabled    = true
    local_only = true
  }
}
