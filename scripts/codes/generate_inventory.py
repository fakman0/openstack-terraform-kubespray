#!/usr/bin/env python3

import json
import os
import sys

# Import yaml module optionally
try:
    import yaml
    HAS_YAML = True
except ImportError:
    HAS_YAML = False

# Path to the terraform outputs JSON file
SCRIPT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TERRAFORM_OUTPUTS_FILE = os.path.join(SCRIPT_DIR, 'terraform_outputs.json')
INVENTORY_FILE = os.path.join(SCRIPT_DIR, 'ansible/inventory/inventory.yaml')

def load_terraform_outputs():
    """Load the Terraform outputs from the JSON file."""
    try:
        with open(TERRAFORM_OUTPUTS_FILE, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading Terraform outputs: {e}", file=sys.stderr)
        sys.exit(1)

def generate_inventory():
    """Generate the Ansible inventory from Terraform outputs."""
    outputs = load_terraform_outputs()
    
    # Create inventory structure
    inventory = {
        'all': {
            'hosts': {},
            'children': {
                'kubernetes': {
                    'children': {
                        'kube_control_plane': {
                            'hosts': {}
                        },
                        'kube_node': {
                            'hosts': {}
                        },
                        'etcd': {
                            'hosts': {}
                        },
                        'k8s_cluster': {
                            'children': {
                                'kube_control_plane': {},
                                'kube_node': {}
                            }
                        },
                        'bastion': {
                            'hosts': {}
                        }
                    }
                }
            },
            'vars': {
                'ansible_user': 'ubuntu',
                'ansible_ssh_private_key_file': '~/.ssh/id_rsa',
                'control_plane_floating_ip': outputs['control_plane_floating_ip'],
                'metallb_floating_ips': outputs['metallb_floating_ips']
            }
        }
    }
    
    # Add master nodes
    for i, ip in enumerate(outputs['master_ips']):
        host_name = f"master-{i+1}"
        
        # Add to kube_control_plane group
        inventory['all']['children']['kubernetes']['children']['kube_control_plane']['hosts'][host_name] = {}
        
        # Add to etcd group
        inventory['all']['children']['kubernetes']['children']['etcd']['hosts'][host_name] = {}
        
        # Add to all hosts
        inventory['all']['hosts'][host_name] = {
            'ansible_host': ip
        }
        
        # If this is master-1, add to bastion group
        if i == 0:
            inventory['all']['children']['kubernetes']['children']['bastion']['hosts'][host_name] = {}
    
    # Add worker nodes
    for i, ip in enumerate(outputs['worker_ips']):
        host_name = f"worker-{i+1}"
        
        # Add to kube_node group
        inventory['all']['children']['kubernetes']['children']['kube_node']['hosts'][host_name] = {}
        
        # Add to all hosts
        inventory['all']['hosts'][host_name] = {
            'ansible_host': ip
        }
    
    return inventory

def main():
    # Ensure inventory directory exists
    os.makedirs(os.path.dirname(INVENTORY_FILE), exist_ok=True)
    
    # Generate inventory
    inventory = generate_inventory()
    
    # Write inventory to file
    with open(INVENTORY_FILE, 'w') as f:
        if HAS_YAML:
            # Write in YAML format
            yaml.dump(inventory, f, default_flow_style=False)
            print(f"Inventory file (YAML format) successfully generated at {INVENTORY_FILE}")
        else:
            # Write in JSON format
            json.dump(inventory, f, indent=2)
            print(f"Inventory file (JSON format) successfully generated at {INVENTORY_FILE}")

if __name__ == "__main__":
    main() 