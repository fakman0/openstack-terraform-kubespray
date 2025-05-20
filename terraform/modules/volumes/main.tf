# Create volumes for master nodes
resource "openstack_blockstorage_volume_v3" "master" {
  count             = var.master_count
  name              = "kubernetes-master-volume-${count.index + 1}"
  size              = var.master_volume_size
}

# Create volumes for worker nodes
resource "openstack_blockstorage_volume_v3" "worker" {
  count             = var.worker_count
  name              = "kubernetes-worker-volume-${count.index + 1}"
  size              = var.worker_volume_size
}
