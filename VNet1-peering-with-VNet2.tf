# ============================================
# = Fichier Terraform pour creer dans Azure  =
# ============================================
# Ceci permet la création de 2 VNet Azure avec chacun un Subnet. 
# Les 2 VNets sont interconnectés avec du VNet Peering Azure
#
# Pour personnaliser recherchez et remplacez Stan par votre chaine !
#

# Définition du ressource group
resource "azurerm_resource_group" "Terra-RG-Stan1" {
  name     = "RG-Stan1"
  location = "West Europe"
}

# Définition des briques suivantes:
# - Un VNet Azure : VNET1
# - Un SubNet dans VNET1 : SubNet1VNet1

# Définition d un VNet
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html
resource "azurerm_virtual_network" "Terra-VNet1" {
  name                = "VNet1"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  address_space       = ["10.0.0.0/8"]
  location            = "${azurerm_resource_group.Terra-RG-Stan1.location}"
  dns_servers         = ["8.8.8.8", "10.0.0.5"]
}

# Définition du subnet SubNet1VNet1
# Plus d info : https://www.terraform.io/docs/providers/azurerm/r/subnet.html 
resource "azurerm_subnet" "Terra-SubNet1VNet1" {
  name                      = "SubNet1VNet1"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet1.name}"
  address_prefix            = "10.0.0.0/16"
}
#==========================================================================================

# Définition des briques suivantes:
# - Un VNet Azure : VNET2
# - Un SubNet dans VNET2 : SubNet1VNet2

# Définition d un VNet
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html
resource "azurerm_virtual_network" "Terra-VNet2" {
  name                = "VNet2"
  resource_group_name = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  address_space       = ["192.168.0.0/16"]
  location            = "${azurerm_resource_group.Terra-RG-Stan1.location}"
  dns_servers         = ["8.8.8.8", "10.0.0.5"]
}

# Définition du subnet SubNet1VNet2
# Plus d info : https://www.terraform.io/docs/providers/azurerm/r/subnet.html 
resource "azurerm_subnet" "Terra-SubNet1VNet2" {
  name                      = "SubNet1VNet2"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet2.name}"
  address_prefix            = "192.168.1.0/24"
}

# Définition du Peering entre VNET1 et VNET2
# Plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_network_peering.html#use_remote_gateways
resource "azurerm_virtual_network_peering" "Terra-Peering1vers2" {
  name                      = "peer1to2"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet1.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.Terra-VNet2.id}"
  allow_virtual_network_access = "true"
}
resource "azurerm_virtual_network_peering" "Terra-Peering2vers1" {
  depends_on = ["azurerm_virtual_network_peering.Terra-Peering1vers2"]
  name                      = "peer2to1"
  resource_group_name       = "${azurerm_resource_group.Terra-RG-Stan1.name}"
  virtual_network_name      = "${azurerm_virtual_network.Terra-VNet2.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.Terra-VNet1.id}"
  allow_virtual_network_access = "true"
}

