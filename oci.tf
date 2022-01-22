variable "oci_tenancy" {
  type        = string
  sensitive   = true
}
variable "oci_user" {
  type        = string
  sensitive   = true
}
variable "oci_subnetid" {
  type        = string
  sensitive   = true
}
variable "oci_fingerprint" {
  type        = string
  sensitive   = true
}
variable "oci_api_private_key" {
  type        = string
  sensitive   = true
}
variable "oci_ssh_public_key" {
  type        = string
  sensitive   = true
}
variable "oci_displayname1" {
  type        = string
}
variable "oci_hostname1" {
  type        = string
}
variable "oci_displayname2" {
  type        = string
}
variable "oci_hostname2" {
  type        = string
}
provider "oci" {
  tenancy_ocid = var.oci_tenancy
  user_ocid = var.oci_user
  fingerprint = var.oci_fingerprint
  private_key = var.oci_api_private_key
  region = "us-phoenix-1"
}

resource "oci_core_instance" "oci_instance1" {
  availability_domain = "yuqr:PHX-AD-1"
  shape = "VM.Standard.E2.1.Micro"
  compartment_id = var.oci_tenancy
  create_vnic_details {
      subnet_id = var.oci_subnetid
      hostname_label = var.oci_hostname1
  }
  display_name = var.oci_displayname1
  metadata = {
      ssh_authorized_keys = var.oci_ssh_public_key
  }
  source_details {
      source_type = "image"
      source_id = "ocid1.image.oc1.phx.aaaaaaaaky4luenz7yvuzz26zipiun6dzbkm7hkon7tppynpm2l6p32aen7a"
  }
}
resource "oci_core_instance" "oci_instance2" {
  availability_domain = "yuqr:PHX-AD-1"
  shape = "VM.Standard.E2.1.Micro"
  compartment_id = var.oci_tenancy
  create_vnic_details {
      subnet_id = var.oci_subnetid
      hostname_label = var.oci_hostname2
  }
  display_name = var.oci_displayname2
  metadata = {
      ssh_authorized_keys = var.oci_ssh_public_key
  }
  source_details {
      source_type = "image"
      source_id = "ocid1.image.oc1.phx.aaaaaaaaky4luenz7yvuzz26zipiun6dzbkm7hkon7tppynpm2l6p32aen7a"
  }
}