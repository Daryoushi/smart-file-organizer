#!/usr/bin/env bash

# ==============================================================================
# Script Name   : organizer.sh
# Description   : Smart File Organizer - Linux Essentials Final Project
# Author        : Abolfazl Daryoushi
# ==============================================================================

set -euo pipefail

# --- Color Definitions for Clean Terminal Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}       Smart File Organizer (Bash)            ${NC}"
echo -e "${BLUE}==============================================${NC}"

# --- Prompt User for Target Directory ---
if [ -n "${1:-}" ]; then
    TARGET_DIR="$1"
else
    read -rp "Please enter the path to the directory you want to organize: " TARGET_DIR
fi

# Expand tilde if present
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"

# --- Validation: Check if Directory Exists ---
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}[ERROR] The specified directory does not exist: '$TARGET_DIR'${NC}" >&2
    exit 1
fi

# Check read and write permissions
if [ ! -r "$TARGET_DIR" ] || [ ! -w "$TARGET_DIR" ]; then
    echo -e "${RED}[ERROR] Insufficient permissions to read/write in: '$TARGET_DIR'${NC}" >&2
    exit 1
fi

echo -e "${GREEN}[OK] Target directory found: $TARGET_DIR${NC}"
