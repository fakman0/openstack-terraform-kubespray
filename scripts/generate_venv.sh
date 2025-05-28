#!/bin/bash

# At this stage, it creates a Python virtual environment and installs required libraries

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." &>/dev/null && pwd)"
VENV_DIR="${ROOT_DIR}/.venv"

# For coloring
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}[*] Creating Python virtual environment (.venv)...${NC}"

# Check for Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[!] Python 3 not found! Please install Python 3.${NC}"
    exit 1
fi

# Delete existing virtual environment if exists
if [ -d "${VENV_DIR}" ]; then
    echo -e "${YELLOW}[*] Removing existing virtual environment...${NC}"
    rm -rf "${VENV_DIR}"
fi

# Create virtual environment
python3 -m venv "${VENV_DIR}"

if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Failed to create virtual environment.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Virtual environment created successfully.${NC}"

# Activate virtual environment and install dependencies
echo -e "${YELLOW}[*] Installing required libraries...${NC}"
source "${VENV_DIR}/bin/activate"

# Update pip
pip install --upgrade pip

# Install PyYAML library
pip install PyYAML

if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Failed to install PyYAML library.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] PyYAML library installed successfully.${NC}"
echo -e "${YELLOW}[*] Virtual environment: ${VENV_DIR}${NC}"
echo -e "${YELLOW}[*] To activate virtual environment: source ${VENV_DIR}/bin/activate${NC}"

echo -e "${GREEN}[+] Setup completed.${NC}" 