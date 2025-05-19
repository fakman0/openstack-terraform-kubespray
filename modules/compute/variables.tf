variable "network_id" {
  description = "ID of the network to attach instances to"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to attach instances to"
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group for instances"
  type        = string
}

variable "master_count" {
  description = "Number of Kubernetes master nodes"
  type        = number
}

variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
}

variable "master_flavor" {
  description = "Flavor for Kubernetes master nodes"
  type        = string
}

variable "worker_flavor" {
  description = "Flavor for Kubernetes worker nodes"
  type        = string
}

variable "image_id" {
  description = "ID of the image to use for instances"
  type        = string
}

variable "keypair_name" {
  description = "Name of the SSH keypair to use for instances"
  type        = string
}

variable "master_volume_ids" {
  description = "IDs of volumes to attach to master nodes"
  type        = list(string)
}

variable "worker_volume_ids" {
  description = "IDs of volumes to attach to worker nodes"
  type        = list(string)
}

variable "control_plane_floating_ip" {
  description = "Floating IP to associate with the first master node"
  type        = string
}

variable "master_port_ids" {
  description = "IDs of pre-created ports for master nodes with allowed address pairs"
  type        = list(string)
}

variable "worker_port_ids" {
  description = "IDs of pre-created ports for worker nodes with allowed address pairs"
  type        = list(string)
}
