provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Enable KV Secrets Engine
resource "null_resource" "enable_kv_secrets_engine" {
  provisioner "local-exec" {
    command = <<EOT
    ROOT_TOKEN=$(grep 'Initial Root Token:' ../install-vault-with-tf/init_output.txt | awk '{print $NF}')
    kubectl exec -it vault-0 -- vault login $ROOT_TOKEN
    kubectl exec -it vault-0 -- vault secrets enable -path=secret kv-v2
    EOT
  }
}

# Vault Auth List
resource "null_resource" "vault_auth_list" {
  depends_on = [null_resource.enable_kv_secrets_engine]
  provisioner "local-exec" {
    command = <<EOT
    ROOT_TOKEN=$(grep 'Initial Root Token:' ../install-vault-with-tf/init_output.txt | awk '{print $NF}')
    kubectl exec -it vault-0 -- vault login $ROOT_TOKEN
    kubectl exec -it vault-0 -- vault auth list
    EOT
  }
}