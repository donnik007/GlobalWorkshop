
data "azurerm_resource_group" "rg" {
  name     = "user0" #username
}

resource "azurerm_network_interface" "nicazureglobal" {  
  name                = "nicuser0" #username
  location            = local.location  
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetazureglobal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pubipazureglobal.id
  }

  depends_on = [
    azurerm_virtual_network.vnetazureglobal,
    azurerm_public_ip.pubipazureglobal
  ]
}

resource "azurerm_public_ip" "pubipazureglobal" {
  name                = "pubipuser0" #username
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.location  
  allocation_method   = "Static"
}

resource "azurerm_windows_virtual_machine" "vmazureglobal" {  
  name                = "vm-user0" #username
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = local.location 
  size                = "Standard_B2s"
  admin_username      = "user0" #username
  admin_password      = "User0@123456" #username (Duża litera, mała litera, znak specjalny, cyfra, min 12 znaków)
  network_interface_ids = [
    azurerm_network_interface.nicazureglobal.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_virtual_network.vnetazureglobal,
    azurerm_network_interface.nicazureglobal
  ]
}

resource "azurerm_virtual_machine_extension" "vmextension" {  
 name = "vmextension"
 virtual_machine_id = azurerm_windows_virtual_machine.vmazureglobal.id 
 publisher = "Microsoft.Compute"
 type = "CustomScriptExtension"
 type_handler_version = "1.10"
 settings = <<SETTINGS
 {
 "commandToExecute": "powershell.exe -Command \"${replace(local.iis_inst, "\\", "\\\\")}; ${replace(local.iis_config, "\\", "\\\\")}\"" 
 }
SETTINGS
} 