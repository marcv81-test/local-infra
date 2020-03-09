output "ip_address" {
  value = "${libvirt_domain.ubuntu.network_interface[0].addresses[0]}"
}
