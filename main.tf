terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "~> 1.18.0"
    }
  }
  required_version = ">= 1.3.5"
}

# ####################################
# Container Security Cluster API
# ####################################
resource "restapi_object" "cluster" {

  provider       = restapi.clusters
  path           = ""
  create_method  = "POST"
  destroy_method = "DELETE"

  data = "{\"name\": \"${var.cluster_name}\",\"description\": \"Playground Cluster\",\"policyID\": \"${var.cluster_policy}\"}"
}

# Store Cluster API Key for use in the helm installation step
locals {
  cluster_apikey = jsondecode(restapi_object.cluster.api_response).apiKey
}

# ####################################
# Container Security Life-cycle
# ####################################
# Creating namespace with the Kubernetes provider is better than auto-creation in the helm_release.
# You can reuse the namespace and customize it with quotas and labels.
resource "kubernetes_namespace" "trendmicro_system" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "container_security" {
  depends_on   = [kubernetes_namespace.trendmicro_system]
  chart        = "https://github.com/trendmicro/cloudone-container-security-helm/archive/master.tar.gz"
  name         = "container-security"
  namespace    = var.namespace
  reuse_values = true

  values = [
    "${file("overrides.yaml")}"
  ]

  set {
    name  = "cloudOne.apiKey"
    value = local.cluster_apikey
  }

  set {
    name  = "cloudOne.endpoint"
    value = "https://container.${var.cloud_one_region}.${var.cloud_one_instance}.trendmicro.com"
  }

  set {
    name  = "cloudOne.jobManager.enabled"
    value = true
  }

  set {
    name  = "cloudOne.runtimeSecurity.enabled"
    value = true
  }

  set {
    name  = "cloudOne.vulnerabilityScanning.enabled"
    value = true
  }

  set {
    name  = "cloudOne.auditlog.enabled"
    value = true
  }
}
