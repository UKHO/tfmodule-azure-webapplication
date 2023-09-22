resource "azurerm_resource_group" "rg" {
    provider = azurerm.prov
    name = "${var.name}-RG"  
    location = "UK South"
}

