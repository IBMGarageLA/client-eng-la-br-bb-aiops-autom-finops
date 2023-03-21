variable "region" {
  type    = string
  default = "us-east"
}

variable "image_name" {
  type    = string
  default = "ibm-debian-9-0-64-minimal-for-vsi"
}

variable "profile" {
  type    = string
  default = "bx2-2x8"
}

variable "zone" {
  type    = string
  default = "us-east-1"
}

variable "resource_prefix" {
  type    = string
  default = "cam"
}
variable "ssh_name" {
  type    = string
  default = ""
}
