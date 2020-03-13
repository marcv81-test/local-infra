terraform {
  required_version = ">= 0.12"
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_network" "network" {
  name      = "infra"
  domain    = "infra"
  addresses = ["192.168.100.0/24"]
  dns {
    enabled    = true
    local_only = true
  }
}

module "test-01" {
  source    = "../modules/ubuntu"
  name      = "test-01"
  cpu       = 1
  memory    = 1024
  network   = libvirt_network.network.name
}

module "test-02" {
  source    = "../modules/ubuntu"
  name      = "test-02"
  cpu       = 1
  memory    = 1024
  network   = libvirt_network.network.name
}
