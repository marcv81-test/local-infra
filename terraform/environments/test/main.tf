terraform {
  required_version = ">= 0.12"
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "network" {
  source = "../../modules/network"
  name   = "test"
  prefix = "192.168.100.0/24"
}

module "server_01" {
  source     = "../../modules/server_stateful"
  name       = "server-01.${module.network.name}"
  cpu        = 1
  memory     = 1024
  network    = module.network.name
  root_image = "../../../resources/images/server-01.provision_root.img"
  data_image = "../../../resources/images/server-01.provision_data.img"
}

module "server_02" {
  source     = "../../modules/server_stateless"
  name       = "server-02.${module.network.name}"
  cpu        = 1
  memory     = 1024
  network    = module.network.name
  root_image = "../../../resources/images/server-02.provision_root.img"
}
