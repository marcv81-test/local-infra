module "network" {
  source = "../network"
  name   = var.name
  prefix = var.prefix
}

module "server_01" {
  source     = "../server_stateful"
  name       = "server-01"
  cpu        = 1
  memory     = 1024
  network    = module.network.name
  root_image = "../../../resources/images/packer.img"
  data_image = "../../../resources/images/empty.img"
}

module "server_02" {
  source     = "../server_stateless"
  name       = "server-02"
  cpu        = 1
  memory     = 1024
  network    = module.network.name
  root_image = "../../../resources/images/packer.img"
}
