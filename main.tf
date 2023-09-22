resource "azurerm_user_assigned_identity" "tf" {
  provider            = azurerm.sub
  name                = "appservice-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_plan" "app_service_plan" {
  provider            = azurerm.sub
  name                = "${var.name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "PremiumV3"
    size = "P1v3"
  }
  tags = var.tags
}

resource "azurerm_app_service" "webapp_service" {
  provider            = azurerm.sub
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  tags                = var.tags
  https_only          = true
  site_config {
    linux_fx_version = "DOTNETCORE|6.0"
    always_on        = true
    http2_enabled    = true
    ftps_state       = "Disabled"
    ip_restriction   = var.ip_restrictions
  }

  depends_on = [
    azurerm_app_service_plan.app_service_plan,
    azurerm_user_assigned_identity.tf
  ]

  app_settings = var.app_settings

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.tf.id]
  }

}

resource "azurerm_app_service_slot" "webapp_service_slot_inactive" {
  provider            = azurerm.sub
  name                = "Inactive"
  location            = var.location
  app_service_name    = azurerm_app_service.webapp_service.name
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  tags                = var.tags
  https_only          = true
  site_config {
    linux_fx_version = "DOTNETCORE|6.0"
    always_on        = true
    http2_enabled    = true
    ftps_state       = "Disabled"
    ip_restriction   = var.ip_restrictions
  }

  depends_on = [
    azurerm_app_service_plan.app_service_plan,
    azurerm_user_assigned_identity.tf
  ]

  app_settings = var.app_settings

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.tf.id]
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "webapp_vnet_integration" {
  provider            = azurerm.sub
  app_service_id = azurerm_app_service.webapp_service.id
  subnet_id      = var.subnet_id
}

resource "azurerm_app_service_slot_virtual_network_swift_connection" "webapp_inactive_slot_vnet_integration" {
  provider            = azurerm.sub
  slot_name      = azurerm_app_service_slot.webapp_service_slot_inactive.name
  app_service_id = azurerm_app_service.webapp_service.id
  subnet_id      = var.subnet_id
}

// First Read the External Key Vault
data "azurerm_key_vault" "certskv" {
  provider            = azurerm.ssl
  name                = var.certificate_key_vault_name
  resource_group_name = var.certificate_key_vault_rg
}

// Now Read the Certificate
data "azurerm_key_vault_certificate" "kvcert" {
  provider     = azurerm.ssl
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.certskv.id
}

//Get Certificate from External KeyVault
resource "azurerm_app_service_certificate" "cert" {
  provider            = azurerm.sub
  name                = var.certificate_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_secret_id = data.azurerm_key_vault_certificate.kvcert.id
}

resource "azurerm_app_service_custom_hostname_binding" "domain" {
  provider            = azurerm.sub
  depends_on = [ azurerm_app_service_certificate.cert ]
  hostname = var.custom_domain
  app_service_name = azurerm_app_service.webapp_service.name
  resource_group_name = var.resource_group_name

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding.example
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_managed_certificate" "tf" {
  provider            = azurerm.sub
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.domain.id
}

resource "azurerm_app_service_certificate_binding" "example" {
  provider            = azurerm.sub
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.domain.id
  certificate_id      = azurerm_app_service_managed_certificate.tf.id
  ssl_state           = "SniEnabled"
}
