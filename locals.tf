locals {
  location="Sweden Central"
  virtual_network = {
    name="vnet-user0"
    address_space="10.1.0.0/16"
}
iis_installation = "Install-WindowsFeature -name Web-Server -IncludeManagementTools"
iis_configuration = "Set-Content -Path 'C:\\inetpub\\wwwroot\\Default.html' -Value 'Hello, this is Azure Global Terraform demo my friend'" #input
iis_inst = "${local.iis_installation}"
iis_config = "${local.iis_configuration}"
}
