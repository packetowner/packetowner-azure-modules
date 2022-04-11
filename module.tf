variable "vnet_src_id" {
  description = "ID of the src vnet to peer"
  type        = string
}

variable "vnet_dest_id" {
  description = "ID of the dest vnet to peer"
  type        = string
}

variable "hub_virtual_network" {
  description = "resource group likely in repo"
  type        = string 
}

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = join("-", ["hub-to", module.spoke_vnet.name])
  resource_group_name          = azurerm_resource_group.rg-network-hub-cus.name
  virtual_network_name         = azurerm_virtual_network.vnet-hub-cus.name
  remote_virtual_network_id    = var.vnet_dest_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = join("-", [module.spoke_vnet.name, "to-hub"])
  resource_group_name          = var.spoke_virtual_network.resource_group
  virtual_network_name         = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id    = var.vnet_src_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

