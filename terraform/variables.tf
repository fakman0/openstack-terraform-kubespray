# OpenStack Authentication Variables #
## If you want to use declarative OpenStack authentication, uncomment the following variables and set the values in terraform.tfvars file ##
# variable "openstack_auth_url" {
#   description = "The OpenStack authentication URL"
#   type        = string
# }

# variable "openstack_user_name" {
#   description = "The OpenStack username"
#   type        = string
# }

# variable "openstack_tenant_name" {
#   description = "The OpenStack tenant/project name"
#   type        = string
# }

# variable "openstack_password" {
#   description = "The OpenStack password"
#   type        = string
#   sensitive   = true
# }

# variable "openstack_region" {
#   description = "The OpenStack region"
#   type        = string
#   default     = "RegionOne"
# }

variable "network_name" {
  description = "Name of the network to create"
  type        = string
  default     = "kubernetes-network"
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "dns_nameservers" {
  description = "DNS nameservers for the subnet"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "router_name" {
  description = "Name of the router to create"
  type        = string
  default     = "kubernetes-router"
}

variable "master_count" {
  description = "Number of Kubernetes master nodes"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
  default     = 3
}

variable "master_flavor" {
  description = "Flavor for Kubernetes master nodes"
  type        = string
  default     = "m1.large"
}

variable "worker_flavor" {
  description = "Flavor for Kubernetes worker nodes"
  type        = string
  default     = "m1.large"
}

variable "image_id" {
  description = "ID of the image to use for instances"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key to use for instances"
  type        = string
  default     = "kubernetes-key"
}

variable "ssh_public_key" {
  description = "Public SSH key content"
  type        = string
}

variable "master_volume_size" {
  description = "Size of master node volumes in GB"
  type        = number
  default     = 100
}

variable "worker_volume_size" {
  description = "Size of worker node volumes in GB"
  type        = number
  default     = 150
}

variable "metallb_floating_ip_count" {
  description = "Number of floating IPs to reserve for MetalLB"
  type        = number
  default     = 1
}
