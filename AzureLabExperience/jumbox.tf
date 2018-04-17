
# Azure Managed disk - pour volume de donnees --> Datadisk1-Jumbox
# plus d info : https://www.terraform.io/docs/providers/azurerm/r/managed_disk.html
resource "azurerm_managed_disk" "Terra-JumboxManagedDisk1" {
  name                 = "${var.JumboxVMName}-Datadisk1"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "128"
}

# carte reseau pour la VM Jumbox
# plus d informations : https://www.terraform.io/docs/providers/azurerm/r/network_interface.html
resource "azurerm_network_interface" "Terra-Jumbox-NIC0" {
  name                = "${var.JumboxVMName}-NIC0"
  location            = "${var.AzureRegion}"
  resource_group_name = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  ip_configuration {
    name                          = "configIPNIC0-Jumbox"
    subnet_id                     = "${azurerm_subnet.Terra-SubnetManagement.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.Terra-PublicIp-Jumbox.id}"
  }
  tags {
    environment = "${var.TagEnvironnement}"
    usage       = "${var.TagUsage}"
  }
}

# Machine virtuelle Jumbox
resource "azurerm_virtual_machine" "Terra-VM-Jumbox" {
  name                  = "${var.JumboxVMName}"
  location              = "${var.AzureRegion}"
  resource_group_name   = "${azurerm_resource_group.Terra-RG-AzureLab.name}"
  network_interface_ids = ["${azurerm_network_interface.Terra-Jumbox-NIC0.id}"]
  vm_size               = "${var.VMSize-jumbox}"
  
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.JumboxVMName}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "128"
  }

storage_data_disk {
    name            = "${azurerm_managed_disk.Terra-JumboxManagedDisk1.name}"
    managed_disk_id = "${azurerm_managed_disk.Terra-JumboxManagedDisk1.id}"
    create_option   = "Attach"
    lun             = 0
    disk_size_gb    = "${azurerm_managed_disk.Terra-JumboxManagedDisk1.disk_size_gb}"
}

  os_profile {
    computer_name  = "${var.JumboxVMName}"
    admin_username = "${var.AdminName}"
    admin_password = "${var.AdminPassword}"
  }

  # more info on os_profile_windows_config : https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile_windows_config
os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }
}