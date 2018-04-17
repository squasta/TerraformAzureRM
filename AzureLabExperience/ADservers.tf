
# Availability Set pour les VM AD DS
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/availability_set.html
resource "azurerm_availability_set" "Terra-AS-ADDS" {
  name                = "${var.ASADDSName}"
  location            = "${var.AzureRegion}"
  managed             =  "true"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

# DEFINITION DU PREMIER DC

# Azure Managed disk - pour volume de donnees --> ADDS1-Datadisk1
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/managed_disk.html
resource "azurerm_managed_disk" "Terra-ADDS1-ManagedDisk1" {
  name                 = "${var.ADDS1VMName}-Datadisk1"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
}

# carte reseau pour ADDS1
# plus d informations : https://www.terraform.io/docs/providers/azurerm/r/network_interface.html
resource "azurerm_network_interface" "Terra-ADDS1-NIC0" {
  name                = "${var.ADDS1VMName}-NIC0"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  ip_configuration {
    name                          = "configIPNIC0-ADDS1"
    subnet_id                     = "${azurerm_subnet.Terra-SubnetADDS.id}"
    private_ip_address_allocation = "dynamic"
  }
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

# Machine virtuelle Azure ADDS1
resource "azurerm_virtual_machine" "Terra-VM-ADDS1" {
  name                  = "${var.ADDS1VMName}"
  location              = "${var.AzureRegion}"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  network_interface_ids = ["${azurerm_network_interface.Terra-ADDS1-NIC0.id}"]
  vm_size               = "${var.VMSize-ADDS}"
  availability_set_id   = "${azurerm_availability_set.Terra-AS-ADDS.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.ADDS1VMName}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "128"
  }

storage_data_disk {
    name            = "${azurerm_managed_disk.Terra-ADDS1-ManagedDisk1.name}"
    managed_disk_id = "${azurerm_managed_disk.Terra-ADDS1-ManagedDisk1.id}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.Terra-ADDS1-ManagedDisk1.disk_size_gb}"
}

  os_profile {
    computer_name  = "${var.ADDS1VMName}"
    admin_username = "${var.AdminName}"
    admin_password = "${var.AdminPassword}"
  }

  # more info on os_profile_windows_config : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile_windows_config
os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }
}


# DEFINITION DU SECOND DC

# Azure Managed disk - pour volume de donnees --> ADDS2-Datadisk1
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/managed_disk.html
resource "azurerm_managed_disk" "Terra-ADDS2-ManagedDisk1" {
  name                 = "${var.ADDS2VMName}-Datadisk1"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
}

# carte reseau pour ADDS1
# plus d informations : https://www.terraform.io/docs/providers/azurerm/r/network_interface.html
resource "azurerm_network_interface" "Terra-ADDS2-NIC0" {
  name                = "${var.ADDS2VMName}-NIC0"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  ip_configuration {
    name                          = "configIPNIC0-ADDS2"
    subnet_id                     = "${azurerm_subnet.Terra-SubnetADDS.id}"
    private_ip_address_allocation = "dynamic"
  }
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

# Machine virtuelle Azure ADDS2
resource "azurerm_virtual_machine" "Terra-VM-ADDS2" {
  name                  = "${var.ADDS2VMName}"
  location              = "${var.AzureRegion}"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  network_interface_ids = ["${azurerm_network_interface.Terra-ADDS2-NIC0.id}"]
  vm_size               = "${var.VMSize-ADDS}"
  availability_set_id   = "${azurerm_availability_set.Terra-AS-ADDS.id}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.ADDS2VMName}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "128"
  }

storage_data_disk {
    name            = "${azurerm_managed_disk.Terra-ADDS2-ManagedDisk1.name}"
    managed_disk_id = "${azurerm_managed_disk.Terra-ADDS2-ManagedDisk1.id}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.Terra-ADDS2-ManagedDisk1.disk_size_gb}"
}

  os_profile {
    computer_name  = "${var.ADDS2VMName}"
    admin_username = "${var.AdminName}"
    admin_password = "${var.AdminPassword}"
  }

  # more info on os_profile_windows_config : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile_windows_config
os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }
}

