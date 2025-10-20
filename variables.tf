variable "resource_group_name" {
  type    = string
  default = "rg-vnet-peering"
}

variable "location" {
  type    = string
  default = "South Africa North"
}

variable "vm_os_size" {
  type    = number
  default = 80
}

variable "allowed_regions" {
  type        = list(strings)
  description = "Allowed list of deployment locations"
  default     = ["eastus", "uknorth", "southafricanorth"]
}

variable "address_space" {
  type = tuple([ string, string,string, string, number, number ])
  description = "The address spaces for the cloud network"
  default = [ "10.0.0.0", "10.1.0.0", "10.0.1.0", "10.0.2.0", 24, 16 ]
  
}