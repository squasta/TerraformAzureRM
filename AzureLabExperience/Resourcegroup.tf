# creation du ressource group
# plus d'informations : https://www.terraform.io/docs/providers/azurerm/r/resource_group.html
resource "azurerm_resource_group" "Terra-RG-AzureLab" {
  name     = "${var.RessourceGroup}"
  location = "${var.AzureRegion}"

  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}
