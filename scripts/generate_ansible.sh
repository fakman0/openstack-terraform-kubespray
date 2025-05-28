#!/bin/bash

# At this stage, it automatically prepares Ansible configuration after Terraform is run
# Sets up the necessary configuration for accessing other servers through the bastion host (master-1)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." &>/dev/null && pwd)"
CODES_DIR="${SCRIPT_DIR}/codes"
TERRAFORM_DIR="${ROOT_DIR}/terraform"
ANSIBLE_DIR="${ROOT_DIR}/ansible"
VENV_DIR="${ROOT_DIR}/.venv"

# For coloring
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for virtual environment
if [ ! -d "${VENV_DIR}" ]; then
    echo -e "${RED}[!] Python virtual environment (.venv) not found. Please run ./setup.sh setup-venv command first.${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${YELLOW}[*] Activating Python virtual environment...${NC}"
source "${VENV_DIR}/bin/activate"

echo -e "${YELLOW}[*] Starting automatic bastion configuration for Ansible...${NC}"

# Check for terraform_outputs.json file
if [ ! -f "${ROOT_DIR}/terraform_outputs.json" ]; then
    echo -e "${YELLOW}[*] terraform_outputs.json file not found, getting Terraform output...${NC}"
    
    # Get Terraform output and save to JSON file
    cd "${TERRAFORM_DIR}"
    terraform output -json > "${ROOT_DIR}/terraform_outputs.json"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}[!] Failed to get Terraform output. Make sure Terraform application was successful.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[+] Terraform output successfully retrieved.${NC}"
fi

# Create Ansible inventory directory
mkdir -p "${ANSIBLE_DIR}/inventory"

# Create Ansible inventory file
echo -e "${YELLOW}[*] Creating Ansible inventory file...${NC}"
python "${CODES_DIR}/generate_inventory.py"

if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Failed to create Ansible inventory file.${NC}"
    exit 1
fi

# Create Ansible configuration file
echo -e "${YELLOW}[*] Creating Ansible configuration file (ansible.cfg)...${NC}"
python "${CODES_DIR}/generate_ansible_cfg.py"

if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Failed to create Ansible configuration file.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Ansible bastion host configuration completed.${NC}"
echo -e "${YELLOW}[*] Make sure your SSH key is added to the agent:${NC}"
echo -e "    ssh-add ~/.ssh/id_rsa"
echo -e "${YELLOW}[*] To run Ansible commands:${NC}"
echo -e "    cd ansible"
echo -e "    ansible all -m ping"
echo -e "    ansible-playbook playbooks/your-playbook.yml"

# Exit virtual environment
deactivate 