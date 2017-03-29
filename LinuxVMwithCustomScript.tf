# ========================
# - This Terraform file will create :
# ========================
# - One Resource Group                         --> RG-linuxVMCustomScript
# - One Virtual Network                        --> VNet-VMLinuxCustomScript
# - one Network Security Group                 --> NSG-LinuxVMCustomScript 
# - One subnets                                --> Subnet-LinuxVMCustomScript
# - One Azure Storage Account                  --> XXXXvmlinuxstorage
# - One container in the Azure Storage Account --> vhds
# - One Public IP                              --> PublicIp-LinuxVMCustomScript
# - One Availability Set                       --> AvailabilitySet-LinuxVMCustomScript
# - One Azure Load Balancer                    --> LB-LinuxVMCustomScript
# - One Linux Virtual machine                  --> VM-LinuxVMCustomScript
# - One VM Extension to call a custom script   --> Extension-CustomScript

# First, you need to define few variables :

# variable to define Azure Resource Group where to deploy Linux VM + customscript
# Variable pour definir le nom du groupe de ressource ou deployer la plateforme
variable "VMLinuxCustomScriptRessourceGroup" {
  type    = "string"
  default = "RG-linuxVMCustomScript"
}

# Variable to define Azure Region where you want to deploy Azure Resources
# Variable pour definir la region Azure ou deployer la plateforme
# To get the list of available Azure Region, use the following Azure CLI command :
# Pour obtenir la liste des valeurs possible via la ligne de commande Azure, executer la commande suivante :
# az account list-locations
variable "AzureRegion" {
  type    = "string"
  default = "westeurope"
}

# variable to define a prefixe to define Azure Storage Account that must be unique
# no more than 5 characters (alpha)
# variable pour definir un prefixe aux noms des comptes de stockage
# /!\ ne pas oublier de mettre son prefixe perso sinon risque d erreur en cas 
# d existence de compte de stockage
# /!\ pas plus de 5 caractères alpha en minuscule
variable "PrefixforStorageAccount" {
  type    = "string"
  default = "stan"
}

# Variable to define admin name
# Variable Nom du compte admin
variable "AdminName" {
  type    = "string"
  default = "Stan"
}

# Variable admin password
# Variable Mot de passe du compte admin
variable "AdminPassword" {
  type    = "string"
  default = "Stan123456"
}

# Variables pour définir l OS a utiliser dans les VM : Publisher, Offer, SKU, version
# Pour obtenir la liste des valeurs possible via la ligne de commande Azure, executer les commandes suivantes :
# az vm image list-publishers -l westeurope
# az vm image list-offers --output table --publisher RedHat --location "west europe"
# az vm image list-skus --output table --offer RHEL --publisher REDHAT --location "west europe"

variable "OSPublisher" {
  type    = "string"
  default = "RedHat"

  #defaut = "Canonical"
}

variable "OSOffer" {
  type    = "string"
  default = "RHEL"

  #defaut = "UbuntuServer"
}

variable "OSsku" {
  type    = "string"
  default = "7.3"

  #defaut = "16.04-LTS"
}

variable "OSversion" {
  type    = "string"
  default = "latest"
}

# congrats now your variable are well defined !!
# bien joue, vos variables sont declarees !!!

# Create one Azure Resource Group
# creation du ressource group
resource "azurerm_resource_group" "Terra-RG-VMLinuxCustomScript" {
  name     = "${var.VMLinuxCustomScriptRessourceGroup}"
  location = "${var.AzureRegion}"
}

# Create One Azure Virtual Network
# Creation d un VNet
# More info : https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html
resource "azurerm_virtual_network" "Terra-VNet-VMLinuxCustomScript" {
  name                = "VNet-VMLinuxCustomScript"
  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  address_space       = ["10.0.0.0/8"]
  location            = "${var.AzureRegion}"

  # by default, you will get Azure DNS as DHCP Option. If you need custom DNS, use the following line
  # par defaut les DNS d Azure sont fournis. Si besoin d utiliser d autres DNS, modifier la ligne suivante
  # dns_servers         = ["8.8.8.8", "10.0.0.5"]
}

# Create one Network Security Group
# Creation des Network Security Group
# Plus d infos : https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html
# NSG SubNet OCP Bastion
resource "azurerm_network_security_group" "Terra-NSG-LinuxVMCustomScript" {
  name                = "NSG-LinuxVMCustomScript"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"

  # rule to allow inbound SSH (TCP 22)
  # regle autorisant SSH en entrée
  security_rule {
    name                       = "OK-SSH-inbound"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create on subnet into VNet : Subnet-LinuxVMCustomScript
# Creation du subnet Subnet-LinuxVMCustomScript
# More info : https://www.terraform.io/docs/providers/azurerm/r/subnet.html 

resource "azurerm_subnet" "Terra-LinuxVMCustomScriptSubnet" {
  name                      = "Subnet-LinuxVMCustomScript"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet-VMLinuxCustomScript.name}"
  address_prefix            = "10.0.0.0/16"
  network_security_group_id = "${azurerm_network_security_group.Terra-NSG-LinuxVMCustomScript.id}"
}

# Create Azure Storage Account to store VM vhd as Page blobs
# creation d un compte de stockage pour le vhd de la VMLinuxCustomScript
# more info : https://www.terraform.io/docs/providers/azurerm/r/storage_account.html
resource "azurerm_storage_account" "Terra-LinuxVMCustomScriptStorage" {
  # le nom du compte de stockage est la concaténation d un prefixe a la chaine vmlinuxstorage
  # XXXXvmlinuxstorage
  name = "${var.PrefixforStorageAccount}vmlinuxstorage"

  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  location            = "${var.AzureRegion}"
  account_type        = "Standard_LRS"
}

# create a container vhds within the Azure Storage Account to storage VM vhds file
# creation d un container dans le storage account pour le stockage des vhds de la VM Linux
# plus d'infos : 
resource "azurerm_storage_container" "Terra-VHDs-VMLinuxCustomScript" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  storage_account_name  = "${azurerm_storage_account.Terra-LinuxVMCustomScriptStorage.name}"
  container_access_type = "private"
}

# Create Public IP for Linux VM (will be associated to Azure Load Balancer)
# IP publique pour la VM Linux (sera associé au load balancer d'Azure)
# more info  / plus d info : https://www.terraform.io/docs/providers/azurerm/r/public_ip.html
resource "azurerm_public_ip" "Terra-PublicIp-LinuxVMCustomScript" {
  name                         = "PublicIp-LinuxVMCustomScript"
  location                     = "${var.AzureRegion}"
  resource_group_name          = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "publicipvmlinuxcustomscript"
}

# Create a NIC for Linux VM
# Creation d une carte reseau pour la VM Linux
# More info / plus d informations : https://www.terraform.io/docs/providers/azurerm/r/network_interface.html
resource "azurerm_network_interface" "Terra-NIC0-LinuxVMCustomScript" {
  name                = "NIC0-LinuxVMCustomScript"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"

  ip_configuration {
    name                          = "configIPNIC0-LinuxVMCustomScript"
    subnet_id                     = "${azurerm_subnet.Terra-LinuxVMCustomScriptSubnet.id}"
    private_ip_address_allocation = "dynamic"

    load_balancer_inbound_nat_rules_ids     = ["${azurerm_lb_nat_rule.Terra-LB-NAT-Rule-LinuxVMCustomScript-SSH.id}"]
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.Terra-LB-BackEndPool-LinuxVMCustomScript.id}"]
  }
}

# create an Availability Set for the VM (not usefull until you put at least 2 VMs with same services inside)
# creation d un Availability Set pour la VM Linux (utile après si plusieurs VM avec les mêmes rôles)
# more info : https://www.terraform.io/docs/providers/azurerm/r/availability_set.html
# Availability Set pour VM Linux
resource "azurerm_availability_set" "Terra-AS-LinuxVMCustomScript" {
  name                = "AvailabilitySet-LinuxVMCustomScript"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
}

# Create an Azure Load Balancer
# you need for that a Vnet, a subnet and a public IP
# Creation du Load Balancer Azure
# il faut un VNet, un subnet, une IP publique, 
# More info, Plus d infos sur le Load Balancer Azure : https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview
resource "azurerm_lb" "Terra-LB-LinuxVMCustomScript" {
  name                = "LB-LinuxVMCustomScript"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"

  frontend_ip_configuration {
    name                 = "LB-LinuxVMCustomScript-PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.Terra-PublicIp-LinuxVMCustomScript.id}"
  }
}

# Create a LB NAT Rule for SSH protocol (TCP 22001 on Internet to TCP 22 on Linux VM)
# Creation d une LB NAT Rule pour le protocole SSH (TCP 22001 côté Internet vers TCP 22 sur la VM Linux)
# More info / plus d info : https://www.terraform.io/docs/providers/azurerm/r/loadbalancer_nat_rule.html
resource "azurerm_lb_nat_rule" "Terra-LB-NAT-Rule-LinuxVMCustomScript-SSH" {
  resource_group_name            = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  loadbalancer_id                = "${azurerm_lb.Terra-LB-LinuxVMCustomScript.id}"
  name                           = "ssh-access"
  protocol                       = "Tcp"
  frontend_port                  = 22001
  backend_port                   = 22
  frontend_ip_configuration_name = "LB-LinuxVMCustomScript-PublicIPAddress"
}

# Create a Back-en pool for Azure Load Balancer
# Create d un Back-End Address Pool pour le Load Balancer Azure
# More info / plus d information : https://www.terraform.io/docs/providers/azurerm/r/loadbalancer_backend_address_pool.html
resource "azurerm_lb_backend_address_pool" "Terra-LB-BackEndPool-LinuxVMCustomScript" {
  resource_group_name = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  loadbalancer_id     = "${azurerm_lb.Terra-LB-LinuxVMCustomScript.id}"
  name                = "BackEndAddressPool-LinuxVMCustomScript"
}

# ----------------------------------------------------
# - create a Linux VM  
# - creation d une VM Linux
# more info / plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html
# API Azure VM : https://docs.microsoft.com/en-us/rest/api/compute/virtualmachines 
resource "azurerm_virtual_machine" "Terra-VM-LinuxVMCustomScript1" {
  name                  = "VM-LinuxVMCustomScript"
  location              = "${var.AzureRegion}"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  network_interface_ids = ["${azurerm_network_interface.Terra-NIC0-LinuxVMCustomScript.id}"]
  vm_size               = "Standard_A2"
  availability_set_id   = "${azurerm_availability_set.Terra-AS-LinuxVMCustomScript.id}"

  # Blob endpoint for the storage account to hold the virtual machine's diagnostic files. 
  # This must be the root of a storage account, and not a storage container
  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.Terra-LinuxVMCustomScriptStorage.primary_blob_endpoint}"
  }

  storage_image_reference {
    publisher = "${var.OSPublisher}"
    offer     = "${var.OSOffer}"
    sku       = "${var.OSsku}"
    version   = "${var.OSversion}"
  }

  storage_os_disk {
    name          = "vmlinuxosdisk"
    vhd_uri       = "${azurerm_storage_account.Terra-LinuxVMCustomScriptStorage.primary_blob_endpoint}${azurerm_storage_container.Terra-VHDs-VMLinuxCustomScript.name}/vmlinuxosdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "VM-LinuxVMCustomScript"
    admin_username = "${var.AdminName}"
    admin_password = "${var.AdminPassword}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    # ssh_keys {
    #   path     = "/home/${var.OCPAdminName}/.ssh/authorized_keys"
    #   key_data = "ssh-rsa COPY PASTE YOUR PUBLIC SSH HERE"
    # }
  }
}

# Create Azure VM Extension for CustomScript
# Creation d une Azure VM Extension de type CustomScript
# More info / Plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html
resource "azurerm_virtual_machine_extension" "Terra-CustomScript-LinuxVMCustomScript1" {
  name                 = "Extension-CustomScript"
  location             = "${var.AzureRegion}"
  resource_group_name  = "${azurerm_resource_group.Terra-RG-VMLinuxCustomScript.name}"
  virtual_machine_name = "${azurerm_virtual_machine.Terra-VM-LinuxVMCustomScript1.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.2"

  settings = <<SETTINGS
    {
        "fileUris": [ "https://raw.githubusercontent.com/squasta/TerraformAzureRM/master/deploy.sh" ],
        "commandToExecute": "bash deploy.sh"
    }
SETTINGS
}
