# server Floating IP address
output "server_interface_id" {
  value = ibm_is_instance.cam-server.primary_network_interface[0].id
}

# server private IP address
output "server_private_ip_address" {
  value = ibm_is_instance.cam-server.primary_network_interface[0].primary_ipv4_address
}

output "server_name" {
  value = ibm_is_instance.cam-server.name
}

output "server_profile" {
  value = ibm_is_instance.cam-server.profile
}

output "cam_tags" {
  value = module.camtags.tags
}