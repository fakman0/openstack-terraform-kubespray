#!/bin/bash

# This script provides an interface for Terraform and Ansible configuration
# and runs other scripts in the correct order

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

# For coloring
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Show usage information
function show_usage {
    echo -e "${BLUE}OpenStack Terraform and Ansible Configuration Tool${NC}"
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ./setup.sh [command]"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo -e "  ${GREEN}setup-all${NC}    : Run all setup steps in sequence"
    echo -e "  ${GREEN}setup-venv${NC}   : Setup Python virtual environment and dependencies"
    echo -e "  ${GREEN}setup-ansible${NC}: Generate Ansible configuration"
    echo -e "  ${GREEN}help${NC}         : Show this help message"
    echo ""
    echo -e "${YELLOW}Example:${NC}"
    echo -e "  ./setup.sh setup-all"
}

# Check command line arguments
if [ $# -lt 1 ]; then
    show_usage
    exit 1
fi

# Make script files executable
chmod +x "${SCRIPTS_DIR}/generate_venv.sh"
chmod +x "${SCRIPTS_DIR}/generate_ansible.sh"
chmod +x "${SCRIPTS_DIR}/codes/generate_inventory.py"
chmod +x "${SCRIPTS_DIR}/codes/generate_ansible_cfg.py"

# Process commands
case "$1" in
    setup-all)
        echo -e "${YELLOW}[*] Starting all setup steps...${NC}"
        
        # Setup Python virtual environment
        "${SCRIPTS_DIR}/generate_venv.sh"
        
        # Generate Ansible configuration
        "${SCRIPTS_DIR}/generate_ansible.sh"
        
        echo -e "${GREEN}[+] All setup steps completed.${NC}"
        ;;
        
    setup-venv)
        echo -e "${YELLOW}[*] Starting Python virtual environment setup...${NC}"
        "${SCRIPTS_DIR}/generate_venv.sh"
        ;;
        
    setup-ansible)
        echo -e "${YELLOW}[*] Starting Ansible configuration...${NC}"
        "${SCRIPTS_DIR}/generate_ansible.sh"
        ;;
        
    help|--help|-h)
        show_usage
        ;;
        
    *)
        echo -e "${RED}[!] Invalid command: $1${NC}"
        show_usage
        exit 1
        ;;
esac

exit 0
