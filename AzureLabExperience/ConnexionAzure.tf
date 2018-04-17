# Ce fichier .tf donne à Terraform les informations 
# du Service Principal Name pour faire des opérations
# sur l'abonnement Azure
# plus d'information : https://stanislas.io/2017/01/02/modeliser-deployer-et-gerer-des-ressources-azure-avec-terraform-de-hashicorp/

provider "azurerm" {
  subscription_id = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  client_id       = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX"
  client_secret   = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx"
  tenant_id       = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
}