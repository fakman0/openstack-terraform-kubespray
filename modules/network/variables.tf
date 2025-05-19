variable "network_name" {
  description = "Name of the network to create"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR for the subnet"
  type        = string
}

variable "dns_nameservers" {
  description = "DNS nameservers for the subnet"
  type        = list(string)
}

variable "router_name" {
  description = "Name of the router to create"
  type        = string
}

variable "metallb_floating_ip_count" {
  description = "Number of floating IPs to reserve for MetalLB"
  type        = number
  default     = 1
}

variable "master_count" {
  description = "Number of Kubernetes master nodes"
  type        = number
}

variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
}
