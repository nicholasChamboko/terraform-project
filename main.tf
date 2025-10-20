# Crearing resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-resources"
  location = var.location[2]
}

# Creating first virtual network
resource "azurerm_virtual_network" "vnet01" {
  name                = "vnet01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name
  address_space       = [element(var.address_space,0)/element(var.address_space,5)] #["10.0.0.0/16"]

  tags = local.common_tags #Used the local variable common_tags
}

# Creating the Second Virtual Network
resource "azurerm_virtual_network" "vnet02" {
  name                = "vnet02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name
  address_space       = [element(var.address_space,1)/element(var.address_space,5)]#["10.1.0.0/16"]
}


# Creating the subnet for Vnet01
resource "azurerm_subnet" "subnet01" {
  name                 = "subnet01"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = [element(var.address_space, 2)/element(var.address_space,4)] #["10.0.1.0/24"]
}

# Creating the subnet for Vnet02
resource "azurerm_subnet" "subnet02" {
  name                 = "subnet02"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = [element(var.address_space,3)/element(var.address_space, 4)]#["10.1.1.0/24"]
}

# Creating Network Interface Card for VM01
resource "azurerm_network_interface" "nic01" {
  name                = "nic01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip01.id
  }
}

# Creating Network Interface Card for VM02
resource "azurerm_network_interface" "nic02" {
  name                = "nic02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet02.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip02.id
  }
}

# Creating the first Virtual Machine in Vnet01
resource "azurerm_windows_virtual_machine" "vm01" {
  name                = "vm01"
  resource_group_name = var.resource_group_name
  location            = azurerm_resource_group.rg.location
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
  ]
  size           = "Standard_DS1_v2"
  admin_username = "nick"
  admin_password = "Kupakwashe1994!@#"

  os_disk {
    name = "myosdisk01"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }


}

# Creating the Second Virtual Machine in Vnet02
resource "azurerm_windows_virtual_machine" "vm02" {
  name                = "vm02"
  resource_group_name = var.resource_group_name
  location            = azurerm_resource_group.rg.location
  network_interface_ids = [
    azurerm_network_interface.nic02.id,
  ]
  size           = "Standard_DS1_v2"
  admin_username = "nick"
  admin_password = "Kupakwashe1994!@#"

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

}

# Creating Vnet Peering from Vnet01 to Vnet02
resource "azurerm_virtual_network_peering" "vnet01-to-vnet02" {
  name                      = "vnet01-to-vnet02"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet02.id
}

# Creating Vnet Peering from Vnet02 to Vnet01
resource "azurerm_virtual_network_peering" "vnet02-to-vnet01" {
  name                      = "vnet02-to-vnet01"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet02.name
  remote_virtual_network_id = azurerm_virtual_network.vnet01.id
}

# Creating public IP for VM01
resource "azurerm_public_ip" "pip01" {
  name                = "pip01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Creating Network Security Group
resource "azurerm_network_security_group" "nsg01" {
  name                = "nsg01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name


  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Connect the network security group to the network interface card of VM01
resource "azurerm_network_interface_security_group_association" "nsg-to-nic01" {
  network_interface_id      = azurerm_network_interface.nic01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}


# Creating public IP for VM02
resource "azurerm_public_ip" "pip02" {
  name                = "pip02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

# Creating Network Security Group
resource "azurerm_network_security_group" "nsg02" {
  name                = "nsg02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name


  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Connect the network security group to the network interface card of VM01
resource "azurerm_network_interface_security_group_association" "nsg-to-nic02" {
  network_interface_id      = azurerm_network_interface.nic02.id
  network_security_group_id = azurerm_network_security_group.nsg02.id
}
