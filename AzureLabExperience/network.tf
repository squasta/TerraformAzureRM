# Definition du VNet
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html
resource "azurerm_virtual_network" "Terra-VNet-AzureLab" {
  name                = "${var.VNetName}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  address_space       = ["10.0.0.0/8"]
  location            = "${var.AzureRegion}"
  # par defaut les DNS d Azure sont fournis. Si besoin d utiliser d autres DNS, modifier la ligne suivante
  # dns_servers         = ["8.8.8.8", "10.0.0.5"]
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

# Subnet AD DS Subnet
# Plus d info : https://www.terraform.io/docs/providers/azurerm/r/subnet.html 
resource "azurerm_subnet" "Terra-SubnetADDS" {
  name                      = "${var.SubnetADDSName}"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet-AzureLab.name}"
  address_prefix            = "10.0.2.0/24"
  #network_security_group_id = "${azurerm_network_security_group.Terra-NSG-OCPBastion.id}"
}

# Subnet Management
# Plus d info : https://www.terraform.io/docs/providers/azurerm/r/subnet.html 
resource "azurerm_subnet" "Terra-SubnetManagement" {
  name                      = "${var.SubnetManagementName}"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet-AzureLab.name}"
  address_prefix            = "10.0.1.0/24"
  #network_security_group_id = "${azurerm_network_security_group.Terra-NSG-OCPBastion.id}"
}

# Network Security Group
# Plus d infos : https://www.terraform.io/docs/providers/azurerm/r/network_security_group.html
# NSG SubNet Management (Jumbox)
resource "azurerm_network_security_group" "Terra-NSG-SubNetManagement" {
  name                = "${var.NSGSubnetManagementName}"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  # regle  autorisant RDP
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
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

# IP publique pour Jumbox
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/public_ip.html
resource "azurerm_public_ip" "Terra-PublicIp-Jumbox" {
  name                         = "${var.PublicIpJumboxName}"
  location                     = "${var.AzureRegion}"
  resource_group_name          = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  public_ip_address_allocation = "static"
  domain_name_label            = "${var.PrefixforPublicIP}${var.PublicIpJumboxName}"
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

