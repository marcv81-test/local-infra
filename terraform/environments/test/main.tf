terraform {
  required_version = ">= 0.12"
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "environment" {
  source = "../../modules/environment"
  name   = "test"
  prefix = "192.168.100.0/24"
}
