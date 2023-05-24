# ####################################
# Kubernetes Configuration
# ####################################
provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

# ####################################
# Container Security API Configuration
# ####################################
provider "restapi" {
  alias                = "clusters"
  uri                  = "https://container.${var.cloud_one_region}.${var.cloud_one_instance}.trendmicro.com/api/clusters"
  debug                = true
  write_returns_object = true

  headers = {
    Authorization = "ApiKey ${var.api_key}"
    Content-Type  = "application/json"
    api-version   = "v1"
  }
}
