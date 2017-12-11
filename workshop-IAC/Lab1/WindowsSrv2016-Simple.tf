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

# Machine virtuelle Azure
# Azure VM
resource "azurerm_virtual_machine" "Terra-VM-Stan1" {
  name                  = "VM-Stan1"
  location              = "West Europe"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  network_interface_ids = ["${azurerm_network_interface.Terra-NIC-Stan1.id}"]
  vm_size               = "Standard_DS1_v2"

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
