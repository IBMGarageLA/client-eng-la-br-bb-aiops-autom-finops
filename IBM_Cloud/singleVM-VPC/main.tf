provider "ibm" {
  region = var.region
}

module "camtags" {
  source = "../Modules/camtags"
}

data "ibm_is_image" "ds_image" {
  name = var.image_name
}

resource "random_integer" "key" {
  min     = 1
  max     = 50000
}

#Create VPC
resource "ibm_is_vpc" "cam_vpc" {
  name = "${var.resource_prefix}-vpc-${random_integer.key.result}"
  tags = module.camtags.tagslist
}

#Create SG
resource "ibm_is_security_group" "cam_security_group" {
  name = "${var.resource_prefix}-sg-${random_integer.key.result}"
  vpc  = ibm_is_vpc.cam_vpc.id
}

#Create ALL source / ANY protocol SG rule
resource "ibm_is_security_group_rule" "cam_security_group_rule_inbound_all" {
  group     = ibm_is_security_group.cam_security_group.id
  direction = "inbound"
}

#Create ALL source / ANY protocol SG rule
resource "ibm_is_security_group_rule" "cam_security_group_rule_outbound_all" {
  group     = ibm_is_security_group.cam_security_group.id
  direction = "outbound"
}


#Create Subnet
resource "ibm_is_subnet" "cam_subnet" {
  name            = "${var.resource_prefix}-subnet-${random_integer.key.result}"
  vpc             = ibm_is_vpc.cam_vpc.id
  zone            = var.zone
  total_ipv4_address_count = 8
}

data "ibm_is_ssh_key" "cam_sshkey" {
  count = var.ssh_name !=""?1:0 
  name = var.ssh_name
}

#Create SSHKey
resource "ibm_is_ssh_key" "cam_sshkey" {
  count = var.public_ssh_key !=""?1:0 
  name       = var.ssh_name
  public_key = var.public_ssh_key
}

#Create VSI
resource "ibm_is_instance" "cam-server" {
  count = 1
  name    = "${var.resource_prefix}-server-vsi-${random_integer.key.result}"
  image   = data.ibm_is_image.ds_image.id
  profile = var.profile

  primary_network_interface {
    subnet = ibm_is_subnet.cam_subnet.id
    security_groups = [ibm_is_security_group.cam_security_group.id]
  }

  vpc  = ibm_is_vpc.cam_vpc.id
  zone = var.zone
  keys = var.public_ssh_key!=""?[ibm_is_ssh_key.cam_sshkey[count.index].id]:[data.ibm_is_ssh_key.cam_sshkey[count.index].id]
  tags = module.camtags.tagslist
}

## Attach floating IP address to VSI
resource "ibm_is_floating_ip" "cam_floatingip" {
  count = 1
  name   = "${var.resource_prefix}-fip-${random_integer.key.result}"
  target = ibm_is_instance.cam-server[count.index].primary_network_interface[0].id
}
