# Variables pour le Lab 2 Terraform

# Variable pour definir la region Azure ou deployer la plateforme
# Pour obtenir la liste des valeurs possible via la ligne de commande Azure, executer la commande suivante :
# az account list-locations
variable "AzureRegion" {
  type    = "string"
  default = "westeurope"
}

# Variable pour definir le nom du groupe de ressource ou deployer la plateforme
variable "RessourceGroup" {
  type    = "string"
  default = "RG-Stan1-Lab1"
}

# pour lister les types de taille de VM possible via la commande az, exécuter la commande suivante
# az vm list-sizes --output table --location "WestEurope"
variable "TailleVM" {
  type    = "string"
  default = "Standard_A2"
}

# Variables pour définir l OS a utiliser dans les VM : Publisher, Offer, SKU, version
# Attention les commandes sont case sensitives !
# Pour obtenir la liste des valeurs possible via la ligne de commande Azure, executer les commandes suivantes :
# az vm image list-publishers -l westeurope
#       pour Windows Server 2016 : MicrosoftWindowsServer
# az vm image list-offers --output table --publisher MicrosoftWindowsServer --location "west europe"
#       pour Windows Server 2 options : WindowsServer, WindowsServerSemiAnnual
# az vm image list-skus --output table --offer WindowsServer --publisher MicrosoftWindowsServer --location "west europe"
#       pas mal de résultats ici : de 2008-R2-SP1 à 2016-Datacenter-smalldisk

variable "OSPublisher" {
  type    = "string"
  default = "MicrosoftWindowsServer"
}

variable "OSOffer" {
  type    = "string"
  default = "WindowsServer"
}

variable "OSsku" {
  type    = "string"
  default = "2016-Datacenter-smalldisk"
}

variable "OSversion" {
  type    = "string"
  default = "latest"
}


# Variable Nom du compte admin
variable "AdminName" {
  type    = "string"
  default = "stan"
}

# Variable Mot de passe (ou cléSSH) du compte admin [c'est pas super sécurisé, c'est pour la démo]
variable "AdminPassword" {
  type    = "string"
  default = "Stan123456"
}