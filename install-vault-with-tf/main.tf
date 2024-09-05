provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Helm chart to install Vault
resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.28.1"  # Specify the version you need

  set {
    name  = "server.standalone.enabled"
    value = "true"
  }
}

# Get Vault Pod Name
data "kubernetes_pod" "vault" {
  metadata {
    name = "vault"
  }
}

# Initialize Vault
resource "null_resource" "vault_init" {
  depends_on = [helm_release.vault]
  provisioner "local-exec" {
    command = <<EOT
    kubectl exec -it vault-0 -- vault operator init -key-shares=1 -key-threshold=1 > init_output.txt
    EOT
  }
  # Run only if Vault is not initialized
  triggers = {
    always_run = "${uuid()}"
  }
}

# Unseal Vault
resource "null_resource" "vault_unseal" {
  depends_on = [null_resource.vault_init]
  provisioner "local-exec" {
    command = <<EOT
    UNSEAL_KEY=$(grep 'Unseal Key 1:' init_output.txt | awk '{print $NF}')
    kubectl exec -it vault-0 -- vault operator unseal $UNSEAL_KEY
    EOT
  }
}

# Output Vault service URL
output "vault_service_url" {
  value = "http://${helm_release.vault.name}.default.svc.cluster.local:8200"
}
