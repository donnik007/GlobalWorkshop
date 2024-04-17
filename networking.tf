resource "azurerm_virtual_network" "vnetazureglobal" {
  name                = local.virtual_network.name
  location            = local.location  
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [local.virtual_network.address_space]
} 

resource "azurerm_subnet" "subnetazureglobal" {    
    name                 = "subnet-user0" #username
    resource_group_name  = data.azurerm_resource_group.rg.name
    virtual_network_name = local.virtual_network.name
    address_prefixes     = ["10.1.1.0/24"]
    depends_on = [
      azurerm_virtual_network.vnetazureglobal
    ]
}

resource "azurerm_network_security_group" "nsgazureglobal" {
  name                = "nsg-user0" #username
  location            = local.location 
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

depends_on = [
    azurerm_virtual_network.vnetazureglobal
  ]
}

resource "azurerm_subnet_network_security_group_association" "appnsg-link" {  
  subnet_id                 = azurerm_subnet.subnetazureglobal.id
  network_security_group_id = azurerm_network_security_group.nsgazureglobal.id

  depends_on = [
    azurerm_virtual_network.vnetazureglobal,
    azurerm_network_security_group.nsgazureglobal
  ]
}

