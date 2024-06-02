# dev-policy.hcl
path "secrets/development/*" {
  capabilities = ["read", "create", "update" ]
}

# sre-policy.hcl
path "secrets/sre/*" {
  capabilities = ["read", "create", "update" ]
}

# managers-policy.hcl
path "secrets/managers/*" {
  capabilities = ["read", "create", "update" ]
}

# compliance-policy.hcl
path "secrets/compliance/*" {
  capabilities = ["read", "create", "update" ]
}
