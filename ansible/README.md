# Automated Bastion Host Configuration with Ansible

This directory contains Ansible files required to configure the Kubernetes cluster created on OpenStack. Ansible is automatically configured to use the `master-1` server created by Terraform as a bastion host.

## Overview

This configuration consists of the following components:

1. **Terraform Output Processing**: Terraform outputs are saved as JSON and used by Ansible.
2. **Dynamic Inventory**: Ansible inventory file is automatically created from Terraform outputs.
3. **Automated Bastion Configuration**: `master-1` server is configured as a bastion host, and all Ansible commands are routed through this server.
4. **SSH Key Management**: SSH keys are used automatically.

## Setup and Execution

After running the Terraform application, follow these steps to complete the setup:

### 1. Set File Permissions

First, make the script files executable:

```bash
chmod +x setup.sh
```

### 2. Setup Virtual Environment and Configuration

Run the setup script:

```bash
./setup.sh setup-all
```

This command does the following:
- Creates a Python virtual environment (.venv)
- Installs required libraries (PyYAML)
- Automatically creates Ansible configuration

## SSH Configuration

To connect through the bastion host, you need to add your SSH key to the agent:

```bash
ssh-add ~/.ssh/id_rsa  # or your other key
```

This ensures your key is forwarded from the bastion server to other servers.

## How It Works

The bastion host (master-1) configuration is implemented in two ways:

1. **ansible.cfg Configuration**: ProxyCommand is defined for all SSH connections
   ```ini
   [ssh_connection]
   ssh_args = -o ForwardAgent=yes ... -o ProxyCommand="ssh -W %h:%p ... ubuntu@BASTION_IP"
   ```

2. **Inventory Configuration**: master-1 is marked as a bastion host

This allows Ansible to access all servers through the bastion host without modifying settings on your personal computer.

## Kubernetes Preparation

We've included playbooks to prepare your servers for Kubernetes installation:

### Preparing Nodes for Kubernetes

To prepare all nodes for Kubernetes installation:

```bash
ansible-playbook playbooks/kubernetes-prep.yml
```

This playbook performs the following tasks:
- Updates the operating system and packages
- Sets hostnames correctly
- Configures timezone
- Installs required packages, including containerd
- Disables swap (required for Kubernetes)
- Loads necessary kernel modules
- Sets required kernel parameters

### Running Specific Tasks

You can run specific tasks using tags:

```bash
ansible-playbook playbooks/kubernetes-prep.yml --tags=swap,kernel
```

For more information about available playbooks and usage, see the [playbooks README](playbooks/README.md).

## Running Commands

You can run Ansible commands as normal:

```bash
ansible all -m ping  # Ping all servers
ansible-playbook playbooks/kubernetes-prep.yml  # Run a playbook
```

## Troubleshooting

If you experience connection problems:

1. Make sure your SSH key is added to the agent:
   ```bash
   ssh-add -l  # List loaded keys
   ```

2. Check that you can connect directly to the bastion host:
   ```bash
   ssh ubuntu@BASTION_IP
   ```

3. Run Ansible in verbose mode:
   ```bash
   ansible -vvv all -m ping
   ``` 