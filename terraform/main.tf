# Create SSH key
resource "openstack_compute_keypair_v2" "kubernetes" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

# Network module
module "network" {
  source = "./modules/network"

  network_name     = var.network_name
  subnet_cidr      = var.subnet_cidr
  dns_nameservers  = var.dns_nameservers
  router_name      = var.router_name
  
  # Pass node counts to network module for port creation
  master_count     = var.master_count
  worker_count     = var.worker_count
  
  # Pass the number of floating IPs to reserve for MetalLB
  metallb_floating_ip_count = var.metallb_floating_ip_count
}

# Volumes module
module "volumes" {
  source = "./modules/volumes"

  master_count      = var.master_count
  worker_count      = var.worker_count
  master_volume_size = var.master_volume_size
  worker_volume_size = var.worker_volume_size
}

# Compute module
module "compute" {
  source = "./modules/compute"

  network_id       = module.network.network_id
  subnet_id        = module.network.subnet_id
  security_group_id = module.network.secgroup_id
  image_id         = var.image_id
  master_count     = var.master_count
  worker_count     = var.worker_count
  master_flavor    = var.master_flavor
  worker_flavor    = var.worker_flavor
  keypair_name     = openstack_compute_keypair_v2.kubernetes.name
  master_volume_ids = module.volumes.master_volume_ids
  worker_volume_ids = module.volumes.worker_volume_ids
  control_plane_floating_ip = module.network.control_plane_floating_ip
  
  # Pass the pre-created ports with allowed address pairs
  master_port_ids  = module.network.master_port_ids
  worker_port_ids  = module.network.worker_port_ids
}

# Output to JSON file for Ansible inventory
resource "local_file" "terraform_outputs" {
  content = jsonencode({
    master_ips               = module.compute.master_ips
    worker_ips               = module.compute.worker_ips
    control_plane_floating_ip = module.network.control_plane_floating_ip
    metallb_floating_ips     = module.network.metallb_floating_ips
    network_id               = module.network.network_id
    subnet_id                = module.network.subnet_id
    router_id                = module.network.router_id
    secgroup_id              = module.network.secgroup_id
  })
  filename = "${path.module}/../terraform_outputs.json"
}
