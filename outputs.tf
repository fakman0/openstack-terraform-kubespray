output "master_ips" {
  description = "IP addresses of the Kubernetes master nodes"
  value       = module.compute.master_ips
}

output "worker_ips" {
  description = "IP addresses of the Kubernetes worker nodes"
  value       = module.compute.worker_ips
}

output "network_id" {
  description = "ID of the created network"
  value       = module.network.network_id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.network.subnet_id
}

output "router_id" {
  description = "ID of the created router"
  value       = module.network.router_id
}

output "secgroup_id" {
  description = "ID of the created security group"
  value       = module.network.secgroup_id
}

output "control_plane_floating_ip" {
  description = "Floating IP assigned to the Kubernetes control plane"
  value       = module.network.control_plane_floating_ip
}

output "metallb_floating_ips" {
  description = "Floating IPs reserved for MetalLB"
  value       = module.network.metallb_floating_ips
}