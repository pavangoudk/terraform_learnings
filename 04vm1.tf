
#VM creation
# Create public IPs
resource "azurerm_public_ip" "memo_publicip1" {
  name                = "memo-public-ip1"
  location            = azurerm_resource_group.memo_rg.location
  resource_group_name = azurerm_resource_group.memo_rg.name
  allocation_method   = "Static"
}

#############################################################################################
#############################################################################################

# Create network interface
resource "azurerm_network_interface" "memo_nic1" {
  name                = "memo-nic1"
  location            = azurerm_resource_group.memo_rg.location
  resource_group_name = azurerm_resource_group.memo_rg.name

  ip_configuration {
    name                          = "memo_nic_configuration1"
    subnet_id                     = azurerm_subnet.memo_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.memo_publicip1.id
  }
}

resource "azurerm_windows_virtual_machine" "memo_vm1" {
  name                = "memo-vm1"
  resource_group_name = azurerm_resource_group.memo_rg.name
  location            = azurerm_resource_group.memo_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.memo_nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_interface_security_group_association" "memo_nic1_nsg_association" {
  network_interface_id      = azurerm_network_interface.memo_nic1.id
  network_security_group_id = azurerm_network_security_group.memo_nsg.id
}
