output "webapp_service" {
  value = azurerm_app_service.webapp_service
}

output "web_app_object_id" {
  value = azurerm_app_service.webapp_service.identity.0.principal_id
}

output "web_app_tenant_id" {
  value = azurerm_app_service.webapp_service.identity.0.tenant_id
}

output "possible_outbound_ip_addresses" {
  value = azurerm_app_service.webapp_service.possible_outbound_ip_addresses
}

output "default_site_hostname" {
  value = azurerm_app_service.webapp_service.default_site_hostname
}

output "webapp_service_name" {
  value = azurerm_app_service.webapp_service.name
}

output "webapp_service_slot_inactive" {
  value = azurerm_app_service_slot.webapp_service_slot_inactive
}

output "webapp_service_slot_inactive_identity_id" {
  value = azurerm_app_service_slot.webapp_service_slot_inactive.identity.0.principal_id
}

output "app_service_plan_id" {
  value = azurerm_app_service_plan.app_service_plan.id
}

output "app_serice_principal_id" {
  value = azurerm_user_assigned_identity.tf.id
}
