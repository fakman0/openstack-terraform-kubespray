# Kubernetes Preparation Playbooks

This directory contains Ansible playbooks for setting up and managing your Kubernetes cluster.

## Playbook Descriptions

### kubernetes-prep.yml

This playbook prepares all nodes for Kubernetes installation by performing the following tasks:

- Updates the operating system and packages
- Sets hostnames correctly
- Configures timezone
- Installs required packages, including containerd
- Disables swap (required for Kubernetes)
- Loads necessary kernel modules
- Sets required kernel parameters

## Usage

### Preparing Nodes for Kubernetes

To prepare all nodes for Kubernetes installation:

```bash
cd ansible
ansible-playbook playbooks/kubernetes-prep.yml
```

### Running on Specific Hosts

To run on specific hosts or groups:

```bash
ansible-playbook playbooks/kubernetes-prep.yml --limit=master-1
```

### Running Specific Tasks with Tags

You can run specific tasks using tags:

```bash
ansible-playbook playbooks/kubernetes-prep.yml --tags=swap,kernel
```

Available tags:
- `update`: OS updates
- `hostname`: Hostname configuration
- `timezone`: Timezone settings
- `packages`: Package installation
- `swap`: Swap disabling
- `kernel`: Kernel modules and parameters

### Running in Check Mode (Dry Run)

To check what changes would be made without actually making them:

```bash
ansible-playbook playbooks/kubernetes-prep.yml --check
```

### Verbose Output

For more detailed output:

```bash
ansible-playbook playbooks/kubernetes-prep.yml -v
```

## Notes

- After running this playbook, a system reboot might be required to apply all changes.
- You can uncomment the reboot task in the playbook to automatically reboot nodes if needed. 