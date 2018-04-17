# Variable pour definir le nom du groupe de ressource ou deployer la plateforme
variable "RessourceGroup" {
  type        = "string"
  description = "Nom du groupe de ressources Azure"
  default     = "RG-AzureLabExperience"
}

# Variable pour definir la region Azure ou deployer la plateforme
# Pour obtenir la liste des valeurs possible via la ligne de commande Azure, executer la commande suivante :
# az account list-locations
variable "AzureRegion" {
  type        = "string"
  description = "Region Azure choisie pour le deploiement"
  default     = "westeurope"
}

# Variable Nom du VNet
variable "VNetName" {
  type    = "string"
  default = "VNet-AzureLab"
}

# Variable Nom du Subnet AD DS
variable "SubnetADDSName" {
  type    = "string"
  default = "Subnet-ADDS"
}

# Variable Nom du Subnet Management
variable "SubnetManagementName" {
  type    = "string"
  default = "Subnet-Management"
}

# Variable Nom du NSG Subnet Management
variable "NSGSubnetManagementName" {
  type    = "string"
  default = "NSG-Subnet-Management"
}

# Variable Nom IP publique jumbox
variable "PublicIpJumboxName" {
  type    = "string"
  default = "publicipjumbox"
}

# Variable Nom VM jumbox
variable "JumboxVMName" {
  type    = "string"
  default = "Jumbox"
}

# Variable Nom 1erDC
variable "ADDS1VMName" {
  type    = "string"
  default = "DC01"
}

# Variable Nom 2emeDC
variable "ADDS2VMName" {
  type    = "string"
  default = "DC02"
}

# Variable Nom de l availability set AD AS
variable "ASADDSName" {
  type    = "string"
  default = "AS-ADDS"
}

# Variable nom du compte administrator renommé
variable "AdminName" {
  type    = "string"
  default = "Stan"
}

# Variable Mot de passe du compte admin
variable "AdminPassword" {
  type    = "string"
  default = "MettreI$IvotreP@ssword"
}

# variable pour definir un prefixe aux nom des IP publiques
# /!\ ne pas oublier de mettre son prefixe perso sinon risque d erreur en cas 
# d existence des noms des IP publiques 
# /!\ pas plus de 5 caractères alpha en minuscule
variable "PrefixforPublicIP" {
  type    = "string"
  default = "stan"
}

# variable TAG définissant l environnement
variable "TagEnvironnement" {
  type    = "string"
  default = "Production"
}

# variable TAG définissant l usage de la plateforme
variable "TagUsage" {
  type        = "string"
  description = "Quel usage pour cette plateforme"
  default     = "POC"
}

# Variable de configuration de gabarit des VM Azure
# Quelques exemples du moins cher (-performant) au plus cher (+performant)
# Standard_A2, Standard_A2_v2, Standard_D2_v2_Promo, Standard_D2_v2, Standard_F2
# pour lister les types de taille de VM possible via la commande az, exécuter la commande suivante
# az vm list-sizes --output table --location "WestEurope"
variable "VMSize-jumbox" {
  type    = "string"
  default = "Standard_B2ms"
}

variable "VMSize-ADDS" {
  type    = "string"
  default = "Standard_B2ms"
}
