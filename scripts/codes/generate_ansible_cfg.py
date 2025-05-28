#!/usr/bin/env python3

import json
import os
import sys

# Path to the terraform outputs JSON file
SCRIPT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TERRAFORM_OUTPUTS_FILE = os.path.join(SCRIPT_DIR, 'terraform_outputs.json')
ANSIBLE_CFG_FILE = os.path.join(SCRIPT_DIR, 'ansible/ansible.cfg')

def load_terraform_outputs():
    """Load the Terraform outputs from the JSON file."""
    try:
        with open(TERRAFORM_OUTPUTS_FILE, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading Terraform outputs: {e}", file=sys.stderr)
        sys.exit(1)

def generate_ansible_cfg(bastion_ip):
    """Generate ansible.cfg content with bastion configuration."""
    cfg_content = f"""[defaults]
inventory = inventory/inventory.yaml
host_key_checking = False
pipelining = True
forks = 10
timeout = 30
ansible_managed = This file is managed by Ansible. Do not edit directly!
remote_user = ubuntu

[inventory]
enable_plugins = script, host_list, yaml, ini

[ssh_connection]
retries = 3
pipelining = True
ssh_args = -o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s -o ProxyCommand="ssh -W %h:%p -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@{bastion_ip}"
"""
    return cfg_content

def main():
    # Load Terraform outputs
    outputs = load_terraform_outputs()
    
    # Get bastion IP (control_plane_floating_ip)
    bastion_ip = outputs.get('control_plane_floating_ip')
    if not bastion_ip:
        print("Error: control_plane_floating_ip not found in Terraform outputs", file=sys.stderr)
        sys.exit(1)
    
    # Generate and write ansible.cfg
    cfg_content = generate_ansible_cfg(bastion_ip)
    with open(ANSIBLE_CFG_FILE, 'w') as f:
        f.write(cfg_content)
    
    print(f"ansible.cfg successfully generated with bastion IP: {bastion_ip}")

if __name__ == "__main__":
    main() 