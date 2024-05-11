# Output Kubernetes configuration
output "config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw  # Raw Kubernetes configuration for AKS cluster
}
