output "network_id" {
  description = "ID of the created network"
  value       = openstack_networking_network_v2.kubernetes.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = openstack_networking_subnet_v2.kubernetes.id
}

output "router_id" {
  description = "ID of the created router"
  value       = openstack_networking_router_v2.kubernetes.id
}

output "secgroup_id" {
  description = "ID of the created security group"
  value       = openstack_networking_secgroup_v2.kubernetes.id
}

output "control_plane_floating_ip" {
  description = "Floating IP allocated for the Kubernetes control plane"
  value       = openstack_networking_floatingip_v2.control_plane.address
}

output "master_port_ids" {
  description = "IDs of the created master node ports"
  value       = openstack_networking_port_v2.master_port[*].id
}

output "worker_port_ids" {
  description = "IDs of the created worker node ports"
  value       = openstack_networking_port_v2.worker_port[*].id
}

output "metallb_floating_ips" {
  description = "Floating IPs reserved for MetalLB"
  value       = openstack_networking_floatingip_v2.metallb_floating_ips[*].address
}

output "metallb_floating_ip_ids" {
  description = "IDs of the floating IPs reserved for MetalLB"
  value       = openstack_networking_floatingip_v2.metallb_floating_ips[*].id
}
