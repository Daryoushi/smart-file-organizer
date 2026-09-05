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

# --- Setup Category Directory Names ---
DIR_IMAGES="Images"
DIR_DOCS="Documents"
DIR_VIDEOS="Videos"
DIR_ARCHIVES="Archives"
DIR_OTHERS="Others"

# Function to get category for a given file extension
get_category() {
    local ext="$1"
    case "$ext" in
        jpg|jpeg|png|gif|bmp|webp|svg|tiff|ico)
            echo "$DIR_IMAGES"
            ;;
        pdf|doc|docx|txt|xls|xlsx|ppt|pptx|odt|csv|md)
            echo "$DIR_DOCS"
            ;;
        mp4|mkv|avi|mov|wmv|flv|webm|m4v)
            echo "$DIR_VIDEOS"
            ;;
        zip|rar|tar|gz|7z|bz2|xz)
            echo "$DIR_ARCHIVES"
            ;;
        *)
            echo "$DIR_OTHERS"
            ;;
    esac
}

echo -e "${YELLOW}Scanning and categorizing files...${NC}"

# Iterate over regular files in TARGET_DIR (non-recursive)
for file_path in "$TARGET_DIR"/*; do
    # Check if any matching file exists (handles empty directory safely)
    [ -e "$file_path" ] || continue

    # Skip subdirectories (do not touch already created category folders)
    [ -f "$file_path" ] || continue

    filename=$(basename "$file_path")

    # Exclude shell scripts and log files from being moved
    case "$filename" in
        *.sh|*.log|log.txt)
            continue
            ;;
    esac

    # Extract file extension
    if [[ "$filename" == *.* ]]; then
        ext="${filename##*.}"
        ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    else
        ext=""
    fi

    # Determine target category folder
    category=$(get_category "$ext")
    dest_dir="$TARGET_DIR/$category"

    # Automatically create category directory if it does not exist
    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir"
    fi

    dest_file="$dest_dir/$filename"
    mv "$file_path" "$dest_file"
done
