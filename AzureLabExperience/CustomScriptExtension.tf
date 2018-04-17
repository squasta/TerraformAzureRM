# Creation d une Azure VM Extension de type CustomScript pour formater les disques de données
# More info / Plus d info : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine_extension.html
# https://docs.microsoft.com/en-us/azure/virtual-machines/windows/extensions-customscript
# to get publisher and type of extension, use the following AZ command :
# az vm extension image list --location westeurope -o table

# Pour le 1er DC
resource "azurerm_virtual_machine_extension" "Terra-CustomScriptExtension-Windows" {
  name                 = "CustomScriptExtension-Windows"
  location             = "${var.AzureRegion}"
  resource_group_name  = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  virtual_machine_name = "${azurerm_virtual_machine.Terra-VM-ADDS1.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = ["azurerm_virtual_machine.Terra-VM-ADDS1"]

  settings = <<SETTINGS
    {
        "fileUris": [ "https://raw.githubusercontent.com/squasta/TerraformAzureRM/master/win-initialize-format-datadisk.ps1" ],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File win-initialize-format-datadisk.ps1"
    }
SETTINGS
}

# Pour le 2eme DC
resource "azurerm_virtual_machine_extension" "Terra-CustomScriptExtension-Windows2" {
  name                 = "CustomScriptExtension-Windows2"
  location             = "${var.AzureRegion}"
  resource_group_name  = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  virtual_machine_name = "${azurerm_virtual_machine.Terra-VM-ADDS2.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  depends_on = ["azurerm_virtual_machine.Terra-VM-ADDS2"]

  settings = <<SETTINGS
    {
        "fileUris": [ "https://raw.githubusercontent.com/squasta/TerraformAzureRM/master/win-initialize-format-datadisk.ps1" ],
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File win-initialize-format-datadisk.ps1"
    }
SETTINGS
}