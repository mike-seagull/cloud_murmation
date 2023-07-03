variable "oci_tenancy" {
  description = "tenancy to the put the instances in. https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm"
  type        = string
  sensitive   = true
}
variable "oci_user" {
  description = "the OCID of the user for whom the key pair is being added. https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm"
  type        = string
  sensitive   = true
}
variable "oci_fingerprint" {
  description = "the fingerprint of the key for the OCID user. https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm"
  type        = string
  sensitive   = true
}
variable "oci_api_private_key" {
  description = "private key for the OCID user. https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm"
  type        = string
  sensitive   = true
}
variable "oci_subnetid" {
  description = "subnet id for the instances"
  type        = string
  sensitive   = true
}
variable "oci_ssh_public_key" {
  description = "public key to log into the instances"
  type        = string
  sensitive   = true
}
variable "oci_displayname1" {
  description = "the displayname that be seen for non-ARM instance1 in the OCI UI"
  type        = string
  default     = "instance1"
}
variable "oci_hostname1" {
  description = "the hostname to give the non-ARM instance1"
  type        = string
  default     = "instance1"
}
variable "oci_displayname2" {
  description = "the displayname that be seen for the non-ARM instance2 in the OCI UI"
  type        = string
  default     = "instance2"
}
variable "oci_hostname2" {
  description = "the hostname to give the non-ARM instance2"
  type        = string
  default     = "instance2"
}
variable "oci_displayname3" {
  description = "the displayname that be seen for the ARM instance in the OCI UI"
  type        = string
  default     = "instance3"
}
variable "oci_hostname3" {
  description = "the hostname to give the ARM instance"
  type        = string
  default     = "instance3"
}
variable "oci_image" {
  description = "image to use for the 2 non-arm instances. Here's a list of the images available: https://docs.oracle.com/en-us/iaas/images/"
  type  = string
  default = "ocid1.image.oc1.phx.aaaaaaaa2eyu6rshjx4zrnwcrvsfv66cwfdwycfzcgui2ai6vmhcabpzz4gq" // Canonical-Ubuntu-22.04-Minimal-2023.05.20-0
}
variable "oci_image_arm" {
  description = "image to use for the arm instance(s). Here's a list of the images available: https://docs.oracle.com/en-us/iaas/images/"
  type  = string
  default = "ocid1.image.oc1.phx.aaaaaaaa5o7vmhhofkjbwcithkt6eur4lpfcp4edvbbcgb2aj6zc7ljynksq" // Canonical-Ubuntu-22.04-Minimal-aarch64-2023.05.20-0
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
  shape = "VM.Standard.E2.1.Micro" // always free
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
      source_id = var.oci_image
  }
}
resource "oci_core_instance" "oci_instance2" {
  availability_domain = "yuqr:PHX-AD-1"
  shape = "VM.Standard.E2.1.Micro" // always free
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
      source_id = var.oci_image
  }
}
resource "oci_core_instance" "oci_instance3" {
  availability_domain = "yuqr:PHX-AD-3"
  shape = "VM.Standard.A1.Flex" // always free
  compartment_id = var.oci_tenancy
  create_vnic_details {
      subnet_id = var.oci_subnetid
      hostname_label = var.oci_hostname3
  }
  shape_config {
      /*
      https://docs.oracle.com/en-us/iaas/Content/FreeTier/freetier_topic-Always_Free_Resources.htm
      these can be changed to support multiple instances
      you can have only a total of 24GB and 4 vCPUs across all arm instances but any permutation of instances
      */
      memory_in_gbs = 24
      ocpus = 4
  }
  display_name = var.oci_displayname3
  metadata = {
      ssh_authorized_keys = var.oci_ssh_public_key
  }
  source_details {
      source_type = "image"
      source_id = var.oci_image_arm
  }
}

output "oci1_internal_ip" {
  sensitive = true
  value = oci_core_instance.oci_instance1.private_ip
}
output "oci1_public_ip" {
  sensitive = true
  value = oci_core_instance.oci_instance1.public_ip
}
output "oci2_internal_ip" {
  sensitive = true
  value = oci_core_instance.oci_instance2.private_ip
}
output "oci2_public_ip" {
  sensitive = true
  value = oci_core_instance.oci_instance2.public_ip
}
output "oci3_internal_ip" {
  sensitive = true
  value = oci_core_instance.oci_instance3.private_ip
}
output "oci3_public_ip" {
  sensitive = true
  value = oci_core_instance.oci_instance3.public_ip
}