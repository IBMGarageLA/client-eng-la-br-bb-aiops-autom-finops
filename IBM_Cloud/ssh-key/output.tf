# server Floating IP address


output "ssh_key_id" {
  value = var.public_ssh_key!=""?one(ibm_is_ssh_key.cam_sshkey[*].id):one(data.ibm_is_ssh_key.cam_sshkey[*].id)
}

