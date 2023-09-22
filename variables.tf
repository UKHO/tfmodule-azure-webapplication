variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
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
