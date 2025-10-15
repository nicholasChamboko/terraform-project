🚀 Azure VNet Peering with Remote Terraform State
This Terraform project demonstrates the deployment of two Azure Virtual Networks (VNets) and establishing VNet Peering between them, enabling seamless communication across the virtual networks. Crucially, the project is configured to manage the Terraform state remotely using Azure Blob Storage, adhering to best practices for production-ready IaC.

✨ Features
This projects demonstrates how to: 

--Create a **Resource Group** in Microsoft Azure using terraform.

--Deploy two **Azure VNets** vnet01 and vnet02 with different address spaces in the same Azure region(South Africa North).

--Creating **subnets** for each VNet

--Deploy two **Virtual Machines** 

--Assign **NICs** and **Public IP Addresses** to the VMs

--Configure **NSGs** for RDP connection from your local PC

--Setup **VNet Peering** for bi-directional communication between the two VNets.

**Note:** that ICMP (ping) is blocked by default in Azure NSGs and Windows Firewall. To test ping between VMs, you need to allow ICMP traffic in NSGs and the Windows firewall.

## Prerequisites
--Terraform >= 1.3.0
--Azurerm  ~>4.0
--Azure Subscription
--Azure CLI to setup the remote State management

Remote State Management: Utilizes the Azure Storage Backend (azurerm) for secure and centralized Terraform state storage.

Firstly create the azure resource group, storage account and container to store your tfstate on Azure
--I used AzureCLI to create the resource group, storage account, blob container and key for the tfstate file.
--Copy backend.tf.example to backend.tf and update with your own Azure details before running Terraform.

## Deployment
1. Clone the repository

2. Initialize Terraform
    terraform init

3. Plan the deployment
    terraform.plan

4. Apply the configuration
    terraform.apply

5. Remember to destroy your infrastructure after to avoid huge Azure Costs
    terraform destroy

## Project Structure
├── main.tf        # Terraform configuration for VNets, subnets, VMs, NICs, NSGs, public IPs, and VNet peering
├── backend.tf      # Backend configuration to create the remote statefile management
├── README.md      # Project documentation
