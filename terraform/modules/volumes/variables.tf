variable "master_count" {
  description = "Number of Kubernetes master nodes"
  type        = number
}

variable "worker_count" {
  description = "Number of Kubernetes worker nodes"
  type        = number
}

variable "master_volume_size" {
  description = "Size of master node volumes in GB"
  type        = number
}

variable "worker_volume_size" {
  description = "Size of worker node volumes in GB"
  type        = number
}
