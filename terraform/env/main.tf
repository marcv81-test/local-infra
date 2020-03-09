terraform {
  required_version = ">= 0.12"
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "server" {
  source    = "../modules/ubuntu"
  name      = "server"
  cpu       = 1
  memory    = 2048
  disk_size = 10737418240
}
