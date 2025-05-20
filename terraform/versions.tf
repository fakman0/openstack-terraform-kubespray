terraform {
  required_version = ">=1.10.5"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "3.0.0"
    }
  }
}

# Variables are not set in this file, they are set in the environment variables with "OS_" prefix
provider "openstack" {
  # auth_url = ""
  # project_id = ""
  # project_name = ""
  # user_domain_name = ""
  # project_domain_id = ""
  # username = ""
  # password = ""
  # region = ""
  # interface = ""
  # identity_api_version = ""
}