/*
* # cloud_murmation
* ### Terraform module for creating free cloud infrastructure in Oracle Cloud and Google Cloud using Terraform Cloud for state management.
* ![alt text](.murmation.png "Murmation")
* ===
*/

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    oci = {
        source = "oracle/oci"
        version = ">= 5.2.0"
    }
    google = {
        source = "hashicorp/google"
        version = ">= 4.70.0"
    }
  }
}
