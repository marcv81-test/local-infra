terraform {
  required_version = ">= 0.12"
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "network" {
  source = "../../modules/network"
  name   = "provision"
  prefix = "192.168.200.0/24"
}

module "server_01" {
  source     = "../../modules/server_stateful"
  name       = "server-01.${module.network.name}"
  cpu        = 1
  memory     = 1024
  network    = module.network.name
  root_image = "../../../resources/images/eoan-server-5g.img"
  data_image = "../../../resources/images/empty-10g.img"
}

module "server_02" {
  source     = "../../modules/server_stateless"
  name       = "server-02.${module.network.name}"
  cpu        = 1
  memory     = 1024
  network    = module.network.name
  root_image = "../../../resources/images/eoan-server-5g.img"
}
