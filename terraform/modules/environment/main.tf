module "network" {
  source = "../network"
  name   = var.name
  prefix = var.prefix
}

module "server_01" {
  source  = "../server"
  name    = "server-01"
  cpu     = 1
  memory  = 1024
  network = module.network.name
}

module "server_02" {
  source  = "../server"
  name    = "server-02"
  cpu     = 1
  memory  = 1024
  network = module.network.name
}
