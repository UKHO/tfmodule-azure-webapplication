variable "dns_zone" {
  description = "alias to create private dns zone - be aware this is dependant on the endpoint"
  default     = "privatelink.azurewebsites.net"
}
variable "vnet_link" {
  description = "alias of the virtual network link"
  default     = ""
}
variable "location" {
  default = "uksouth"
}
variable "network_type" {
  description = "type of connection"
  default     = "network"
}
variable "private_connection" {
  description = "endpoint resource id (for example [/subscriptions/SUBID/resourceGroups/RGNAME/providers/Microsoft.Web/sites/APP_SERVICE_NAME])"
  type        = list(string)
  default     = [""]
}
variable "zone_group" {
  description = "private dns zone group"
  default     = ""
}
variable "pe_identity" {
  description = "identity that will create all the private endpoint resources required"
  default     = ""
}
variable "pe_environment" {
  description = "environment for private endpoint (for example dev | prd | qa | pre)"
  default     = ""
}
variable "pe_vnet_rg" {
  description = "this is the rg for the spoke vnet"
  default     = ""
}
variable "pe_vnet_name" {
  description = "vnet name for the private endpoint"
  default     = ""
}
variable "pe_subnet_name" {
  description = "subname that the private endpoint will associate"
  default     = ""
}
variable "subresource_names" {
  description = "array of sub resources, if you require additional subresources please define"
  default     = ["sites"]
}
variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "app_settings" {
  type = map(string)
}
variable "tags" {
}
variable "ip_restrictions" {
  type = list(any)
}
variable "custom_domain" {
  type = string
}
variable "certificate_name" {
  type = string
}
variable "certificate_key_vault_name" {
  type = string
}
variable "certificate_key_vault_rg" {
  type = string
}