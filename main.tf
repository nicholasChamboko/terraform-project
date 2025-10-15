
# The constraint "~>4.0" allows non-breaking updates within major version 4.x.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
  required_version = ">=1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = "a48c9a50-8801-41f0-b455-f7394885ad34"
}

# Crearing resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet-peering"
  location = "South Africa North"
}

# Creating first virtual network
resource "azurerm_virtual_network" "vnet01" {
  name                = "vnet01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Creating the Second Virtual Network
resource "azurerm_virtual_network" "vnet02" {
  name                = "vnet02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}


# Creating the subnet for Vnet01
resource "azurerm_subnet" "subnet01" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Creating the subnet for Vnet02
resource "azurerm_subnet" "subnet02" {
  name                 = "subnet02"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet02.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Creating Network Interface Card for VM01
resource "azurerm_network_interface" "nic01" {
  name                = "nic01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
    
  }
}

# Creating Network Interface Card for VM02
resource "azurerm_network_interface" "nic02" {
  name                = "nic02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet02.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating the first Virtual Machine in Vnet01
resource "azurerm_windows_virtual_machine" "vm01" {
  name                = "vm01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  network_interface_ids = [
    azurerm_network_interface.nic01.id,
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

# Creating the Second Virtual Machine in Vnet02
resource "azurerm_windows_virtual_machine" "vm02" {
  name                = "vm02"
  resource_group_name = azurerm_resource_group.rg.name
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
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet01.name
  remote_virtual_network_id = azurerm_virtual_network.vnet02.id
}

# Creating Vnet Peering from Vnet02 to Vnet01
resource "azurerm_virtual_network_peering" "vnet02-to-vnet01" {
  name                      = "vnet02-to-vnet01"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet02.name
  remote_virtual_network_id = azurerm_virtual_network.vnet01.id
}