# ####################################
# Variables
# ####################################
# Container Security
variable "cluster_policy" {
  type    = string
}

variable "cluster_name" {
  default = "by_terraform"
}

# Cloud One
variable "cloud_one_region" {
  default = "us-1"
}

variable "cloud_one_instance" {
  default = "cloudone"
}

variable "api_key" {
  type    = string
}

# Kubernetes
variable "kube_config" {
  default = "~/.kube/config"
}

variable "namespace" {
  default = "trendmicro-system"
}
