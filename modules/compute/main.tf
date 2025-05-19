# Create master nodes
resource "openstack_compute_instance_v2" "master" {
  count           = var.master_count
  name            = "kubernetes-master-${count.index + 1}"
  image_id        = var.image_id
  flavor_name     = var.master_flavor
  key_pair        = var.keypair_name
  security_groups = []  # Security groups are already assigned to the ports

  # Use the pre-created port with allowed address pairs
  network {
    port = var.master_port_ids[count.index]
  }

  user_data = file("${path.module}/cloud-init.yaml")
}

# Create worker nodes
resource "openstack_compute_instance_v2" "worker" {
  count           = var.worker_count
  name            = "kubernetes-worker-${count.index + 1}"
  image_id        = var.image_id
  flavor_name     = var.worker_flavor
  key_pair        = var.keypair_name
  security_groups = []  # Security groups are already assigned to the ports

  # Use the pre-created port with allowed address pairs
  network {
    port = var.worker_port_ids[count.index]
  }

  user_data = file("${path.module}/cloud-init.yaml")
}

# Attach volumes to master nodes
resource "openstack_compute_volume_attach_v2" "master_volume_attachment" {
  count       = var.master_count
  instance_id = openstack_compute_instance_v2.master[count.index].id
  volume_id   = var.master_volume_ids[count.index]
}

# Attach volumes to worker nodes
resource "openstack_compute_volume_attach_v2" "worker_volume_attachment" {
  count       = var.worker_count
  instance_id = openstack_compute_instance_v2.worker[count.index].id
  volume_id   = var.worker_volume_ids[count.index]
}

# Get the first master node's port for floating IP attachment
data "openstack_networking_port_v2" "master_port" {
  port_id = var.master_port_ids[0]
}

# Associate floating IP with the first master node's port
resource "openstack_networking_floatingip_associate_v2" "master_control_plane" {
  floating_ip = var.control_plane_floating_ip
  port_id     = data.openstack_networking_port_v2.master_port.id
}