# Ce modele Terraform permet de deployer une VM Windows Server 2016 avec le disque System en mode managed Disk
# et un disque de donnees additionnel de type managed disk. 
# Informations complementaires sur les disques manages dans Azure et Terraform :
# https://docs.microsoft.com/en-us/azure/storage/storage-managed-disks-overview
# https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html
# https://www.terraform.io/docs/providers/azurerm/r/managed_disk.html 
#
# Pour personnaliser votre deploiement, rechercher et remplacer toutes les occurrences de la chaine "Stan1"
# par votre valeur personnalisée
#
# This Terraform template deploy a Windows Server 2016 VM with 2 Azure managed disk : one for system
# one for data
# Additionnal information on Azure Managed disk and Terraform
# https://docs.microsoft.com/en-us/azure/storage/storage-managed-disks-overview
# https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html
# https://www.terraform.io/docs/providers/azurerm/r/managed_disk.html 
#
# To customize your deployment : search and replace all occurence of "Stan1" string with your custom string

#variable definition
# voir dans le fichier Variables-Terraform-Lab1.tf
# have a look in Variables-Terraform-Lab1.tf file


# Azure ressource group
# Resource Groupe Azure
resource "azurerm_resource_group" "Terra-RG-Stan1" {
  name     = "RG-Stan1-Lab1"
  location = "West Europe"
}

# OMS Workspace
# more information : https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html
resource "azurerm_log_analytics_workspace" "Terra-OMSWorkspace-Stan1" {
  name                = "OMSWorkspace-Stan1"
  location            = "${azurerm_resource_group.Terra-RG-Stan1.location}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  # Possible values : Free, PerNode, Premium, Standard, Standalone and Unlimited
  # working values (that I tested with success in october 2017) : Standard, Standalone, PerNode
  # Standalone = Pricing per Gb, PerNode = OMS licence 
  # More info : https://azure.microsoft.com/en-us/pricing/details/log-analytics/
  sku                 = "Standard"
  # Possible values : 30 to 730
  retention_in_days   = 30
}


# VNet Azure
# Azure VNet
resource "azurerm_virtual_network" "Terra-VNet-Stan1" {
  name                = "Vnet-Stan1"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"
}

# Subnet dans le VNet Azure
# Subnet inside Azure VNet
resource "azurerm_subnet" "Terra-Subnet-Stan1" {
  name                 = "Subnet-Stan1"
  resource_group_name  = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  virtual_network_name = "${azurerm_virtual_network.Terra-VNet-Stan1.name}"
  address_prefix       = "10.0.2.0/24"
  network_security_group_id = "${azurerm_network_security_group.Terra-NSG-Stan1.id}"
}

# Creation des Network Security Group
# Plus d infos : https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html
# NSG SubNet Subnet-Stan1
resource "azurerm_network_security_group" "Terra-NSG-Stan1" {
  name                = "NSG-Stan1"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"

  security_rule {
    name                       = "OK-HTTP-entrant"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "OK-HTTPS-entrant"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # regle autorisant RDP (Remote Desktop Protocol)
  security_rule {
    name                       = "OK-RDP-entrant"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}


# creation IP publique pour la Nic de la VM
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/public_ip.html
resource "azurerm_public_ip" "Terra-PublicIp-Stan1" {
  name                         = "PublicIp-Stan1"
  location                     = "West Europe"
  resource_group_name          = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "publiciplab1-stan1"
}


# Carte reseau de la VM attache au Subnet
# NIC VM attached to Subnet
resource "azurerm_network_interface" "Terra-NIC-Stan1" {
  name                = "Nic-Stan1"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"

  ip_configuration {
    name                          = "Stan1-ipconfiguration"
    subnet_id                     = "${azurerm_subnet.Terra-Subnet-Stan1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.Terra-PublicIp-Stan1.id}"
  }
}

# Azure disk manage
# Azure Managed Disk
resource "azurerm_managed_disk" "Terra-ManagedDisk-Stan1" {
  name                 = "ManagedDisk-Stan1"
  location             = "West Europe"
  resource_group_name  = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

# creation d un Availability Set pour les VM
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/availability_set.html
# Availability Set for VM HA
resource "azurerm_availability_set" "Terra-AvailabilitySet-Stan1" {
  name                = "AvailabilitySet-Stan1"
  location            = "West Europe"
  managed             = "true"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"
}

# Machine virtuelle Azure
# Azure VM
resource "azurerm_virtual_machine" "Terra-VM-Stan1" {
  name                  = "VM-Stan1"
  location              = "West Europe"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  network_interface_ids = ["${azurerm_network_interface.Terra-NIC-Stan1.id}"]
  vm_size               = "Standard_DS1_v2"
  availability_set_id   = "${azurerm_availability_set.Terra-AvailabilitySet-Stan1.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.Terra-ManagedDisk-Stan1.name}"
    managed_disk_id = "${azurerm_managed_disk.Terra-ManagedDisk-Stan1.id}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.Terra-ManagedDisk-Stan1.disk_size_gb}"
  }

   os_profile {
    computer_name  = "Windows-Stan1"
    admin_username = "stan"
    # change here with your password
    # changer ici le mot de passe 
    admin_password = "Stan123456"
  }

# more info on os_profile_windows_config : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile_windows_config
os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }
  
}


# Create Azure VM Extension for OMS
# Creation d une Azure VM Extension de type OMS
# More info / Plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html
resource "azurerm_virtual_machine_extension" "Terra-VMExtensionOMS-Stan1" {
  name                 = "VMExtensionOMS-Stan1"
  location             = "West Europe"
  resource_group_name  = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  virtual_machine_name = "${azurerm_virtual_machine.Terra-VM-Stan1.name}"
  publisher            = "Microsoft.EnterpriseCloud.Monitoring"
  type                 = "MicrosoftMonitoringAgent"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "workspaceId": "[reference(resourceId('Microsoft.OperationalInsights/workspaces/', 'OMSWorkspace-Stan1'), '2015-03-20').customerId]"
    }
SETTINGS

protected_settings = <<PROTECTED_SETTINGS
{
"workspaceKey": "[listKeys(resourceId('Microsoft.OperationalInsights/workspaces/', 'OMSWorkspace-Stan1'), '2015-03-20').primarySharedKey]"
}
PROTECTED_SETTINGS


}
