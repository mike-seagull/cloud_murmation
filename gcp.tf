variable "gcp_project" {
  description = "the human-readable name for the project to put the instance in *not the id*"
  type        = string
  sensitive   = true
}
variable "gcp_hostname" {
  description = "the hostname to give the instance"
  type        = string
  default     = "instance"
}
variable "gcp_displayname" {
  description = "the displayname that be seen in the GCP UI"
  type        = string
  default     =  "instance"
}
variable "gcp_map_of_ssh_usernames_and_public_keys" {
  description = "map of ssh usernames and public keys. at a minimum you will need a key for the ubuntu user, ex: { ubuntu = 'mypublickeyeample'}"
  type        = map
  sensitive   = true
}

variable "gcp_credentials" {
  description = "the credentials for the GCP Terraform provider. Instructions for getting them are here: https://support.hashicorp.com/hc/en-us/articles/4406586874387-How-to-set-up-Google-Cloud-GCP-credentials-in-Terraform-Cloud"
  type        = string
  sensitive   = true  
}
variable "image" {
  description = "image to use for the instance. 'Premium' images are not free. Here are some of the images available: https://cloud.google.com/compute/docs/images/os-details"
  type        = string
  default     = "ubuntu-2204-lts"
}
variable "network" {
  description = "network name to put the instance in."
  type        = string
  default     = "default"
}


provider "google" {
  project = var.gcp_project
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = var.gcp_credentials
}
resource "google_compute_instance" "gcp_instance" {
  name         = var.gcp_displayname
  machine_type = "e2-micro" // always free
  hostname     = var.gcp_hostname
  metadata     = {
    // at a minimum you will need a key for the ubuntu user
    ssh-keys = join("\n", [for user, key in var.gcp_map_of_ssh_usernames_and_public_keys : "${user}:${key}"])
  }

  boot_disk {
    initialize_params {
      size = 30 // largest size available in GB
      image = var.image
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = var.network
    access_config {
    }
  }
}