variable "gcp_project" {
  type = string
  sensitive = true
}
variable "gcp_hostname" {
  type = string
}
variable "gcp_displayname" {
  type = string
}
variable "gcp_ssh_public_key" {
  type = string
  sensitive = true
}
variable "gcp_credentials" {
  type = string
  sensitive = true  
}
provider "google" {
  project = var.gcp_project
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = var.gcp_credentials
}
resource "google_compute_instance" "gcp_instance" {
  name         = var.gcp_displayname
  machine_type = "e2-micro"
  hostname = var.gcp_hostname
  metadata = {
    ssh-keys = "ubuntu:${var.gcp_ssh_public_key}"
  }

  boot_disk {
    initialize_params {
      size = 30
      image = "ubuntu-2004-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}