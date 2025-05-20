output "master_ips" {
  description = "IP addresses of the Kubernetes master nodes"
  value       = openstack_compute_instance_v2.master[*].access_ip_v4
}

output "worker_ips" {
  description = "IP addresses of the Kubernetes worker nodes"
  value       = openstack_compute_instance_v2.worker[*].access_ip_v4
}

output "master_private_ips" {
  description = "Private IP addresses of the Kubernetes master nodes"
  value       = openstack_compute_instance_v2.master[*].access_ip_v4
}

output "master_instance_ids" {
  description = "IDs of the master instances"
  value       = openstack_compute_instance_v2.master[*].id
}

output "worker_instance_ids" {
  description = "IDs of the worker instances"
  value       = openstack_compute_instance_v2.worker[*].id
}
