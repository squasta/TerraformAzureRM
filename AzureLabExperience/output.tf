# --------------------
# - Output
# --------------------

output "IP Publique de la VM Jumbox" {
  value = "${azurerm_public_ip.Terra-PublicIp-Jumbox.ip_address}"
}

output "FQDN de la VMLinux " {
  value = "${azurerm_public_ip.Terra-PublicIp-Jumbox.fqdn}"
}

output "IP Interne de la VM ADDS1" {
  value = "${ azurerm_network_interface.Terra-ADDS1-NIC0.private_ip_address}"
}

output "IP Interne de la VM ADDS2" {
  value = "${ azurerm_network_interface.Terra-ADDS2-NIC0.private_ip_address}"
}