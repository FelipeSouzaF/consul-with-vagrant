# Configure the Consul provider
provider "consul" {
  address    = "${var.consul_address}:${var.consul_port}"
  datacenter = var.consul_server
  token      = var.consul_token
}

locals {
  consul_policies = {
    "management" = {
      datacenters = [var.consul_server]

      rules = templatefile("${path.module}/policies/management.tftpl", {})
    }
    "tenant_service" = {
      datacenters = [var.consul_server]

      rules = templatefile("${path.module}/policies/tenant_service.tftpl", {})
    }
  }

  consul_tokens = {
    "management" = {
      description = "Token to manage consul resources."

      policies = [
        consul_acl_policy.policies["management"].name
      ]
    }
    "tenant_service" = {
      description = "Token to manage service tenant_service."

      policies = [
        consul_acl_policy.policies["tenant_service"].name
      ]
    }
  }
}

resource "consul_acl_policy" "policies" {
  for_each = local.consul_policies

  name        = each.key
  datacenters = each.value.datacenters
  rules       = each.value.rules
}

resource "consul_acl_token" "tokens" {
  for_each = local.consul_tokens

  description = each.value.description
  policies    = each.value.policies
  local       = false

  depends_on = [consul_acl_policy.policies]
}

data "consul_acl_token_secret_id" "token_secrets" {
  for_each = consul_acl_token.tokens

  accessor_id = each.value.id
}
