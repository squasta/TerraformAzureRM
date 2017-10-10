# this Terraform File will create :
# - an Azure Resource Group
# - an Azure Logs Analytics Workspace (cf. https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-overview)
# - Output all usefull informations including Azure Logs Analytics Portal URL
# - Search, find & replace "-Stan1" string to personnalize !

resource "azurerm_resource_group" "Terra-RG-LogsAnalytics" {
  name     = "RG-LogsAnalytics"
  location = "West Europe"
}

 # more information : https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html
resource "azurerm_log_analytics_workspace" "Terra-OMSWorkspace-Stan1" {
  name                = "OMSWorkspace-Stan1"
  location            = "${azurerm_resource_group.Terra-RG-LogsAnalytics.location}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-LogsAnalytics.name}"
  # Possible values : Free, PerNode, Premium, Standard, Standalone and Unlimited
  # working values (that I tested with success in october 2017) : Standard, Standalone, PerNode
  # Standalone = Pricing per Gb, PerNode = OMS licence 
  # More info : https://azure.microsoft.com/en-us/pricing/details/log-analytics/
  sku                 = "Standard"
  # Possible values : 30 to 730
  retention_in_days   = 30
}

# Output post deployment
output "Workspace ID " {
    value="${azurerm_log_analytics_workspace.Terra-OMSWorkspace-Stan1.id}"
}

output "Workspace Customer ID" {
    value="${azurerm_log_analytics_workspace.Terra-OMSWorkspace-Stan1.workspace_id}"
}

output "Workspace primary Shared Key " {
    value="${azurerm_log_analytics_workspace.Terra-OMSWorkspace-Stan1.primary_shared_key}"
}

output "Workspace Secondary Shared Key " {
    value="${azurerm_log_analytics_workspace.Terra-OMSWorkspace-Stan1.secondary_shared_key}"
}

output "Portal URL " {
    value="${azurerm_log_analytics_workspace.Terra-OMSWorkspace-Stan1.portal_url}"
}