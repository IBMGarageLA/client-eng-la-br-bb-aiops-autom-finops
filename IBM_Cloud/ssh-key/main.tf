provider "ibm" {
  region = var.region
}

module "camtags" {
  source = "../Modules/camtags"
}

#Find SSHKey
data "ibm_is_ssh_key" "cam_sshkey" {
  count = var.public_ssh_key ==""?1:0 
  name = var.ssh_name
}

#Create SSHKey
resource "ibm_is_ssh_key" "cam_sshkey" {
  count = var.public_ssh_key !=""?1:0 
  name       = var.ssh_name
  public_key = var.public_ssh_key
}

