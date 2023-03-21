provider "ibm" {
  region = var.region
}

module "camtags" {
  source = "../Modules/camtags"
}

## Attach floating IP address to VSI
resource "ibm_is_floating_ip" "cam_floatingip" {
  name   = var.floatingip_name
  target = var.vsi_id
}

