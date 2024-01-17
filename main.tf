locals {
  environment = try(terraform.workspace, "staging")
}

module "production" {
  source = "./environments/production"
  count  = local.environment == "production" ? 1 : 0
}

module "staging" {
  source = "./environments/staging"
  count  = local.environment == "staging" ? 1 : 0
}

locals {
  cluster_name = {
    production = try(module.production[0].cluster_name, null)
    staging    = try(module.staging[0].cluster_name, null)
  }
  cluster_endpoint = {
    production = try(module.production[0].cluster_endpoint, null)
    staging    = try(module.staging[0].cluster_endpoint, null)
  }
  cluster_ca_certificate = {
    production = try(module.production[0].cluster_ca_certificate, null)
    staging    = try(module.staging[0].cluster_ca_certificate, null)
  }
}