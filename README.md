🚀 Azure VNet Peering with Remote Terraform State
This Terraform project deploys two Azure Virtual Networks (VNets) and establishes VNet Peering between them, enabling seamless communication across the virtual networks. Crucially, the project is configured to manage the Terraform state remotely using Azure Blob Storage, adhering to best practices for production-ready IaC.

✨ Features
Two Azure VNets: Deploys vnet-a and vnet-b in the same Azure region.

VNet Peering: Configures bi-directional peering between the two VNets.

Remote State Management: Utilizes the Azure Storage Backend (azurerm) for secure and centralized Terraform state storage.

Firstly create the azure resource group, storage account and container to store your tfstate on Azure

Copy backend.tf.example to backend.tf and update with your own Azure details before running Terraform.