output "master_volume_ids" {
  description = "IDs of the created master volumes"
  value       = openstack_blockstorage_volume_v3.master[*].id
}

output "worker_volume_ids" {
  description = "IDs of the created worker volumes"
  value       = openstack_blockstorage_volume_v3.worker[*].id
}
