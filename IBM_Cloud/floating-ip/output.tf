# server Floating IP address


output "floating_IP_address" {
  value = ibm_is_floating_ip.cam_floatingip.address
}

output "floating_IP_status" {
  value = ibm_is_floating_ip.cam_floatingip.status
}