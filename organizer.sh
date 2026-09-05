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

# --- Setup Logging ---
LOG_FILE="$TARGET_DIR/log.txt"

log_action() {
    local message="$1"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $message" >> "$LOG_FILE"
}

# Initialize session log
log_action "================== SESSION START =================="
log_action "Target Directory: $TARGET_DIR"

# --- Counters for Statistics ---
COUNT_IMAGES=0
COUNT_PDF=0
COUNT_DOCS_OTHER=0
COUNT_VIDEOS=0
COUNT_ZIP=0
COUNT_ARCHIVES_OTHER=0
COUNT_OTHERS=0
TOTAL_MOVED=0

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

# Function to resolve duplicate file names by appending a counter (_1, _2, ...)
resolve_destination_path() {
    local target_dir="$1"
    local original_name="$2"

    local target_path="$target_dir/$original_name"
    if [ ! -e "$target_path" ]; then
        echo "$target_path"
        return 0
    fi

    local base_name
    local ext_suffix=""

    if [[ "$original_name" == *.* ]]; then
        base_name="${original_name%.*}"
        ext_suffix=".${original_name##*.}"
    else
        base_name="$original_name"
    fi

    local counter=1
    local new_path="$target_dir/${base_name}_${counter}${ext_suffix}"
    while [ -e "$new_path" ]; do
        counter=$((counter + 1))
        new_path="$target_dir/${base_name}_${counter}${ext_suffix}"
    done

    echo "$new_path"
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
        log_action "[DIR CREATED] Created directory '$category'"
    fi

    # Handle duplicate filenames safely
    final_dest_path=$(resolve_destination_path "$dest_dir" "$filename")
    final_dest_name=$(basename "$final_dest_path")

    if [ "$filename" != "$final_dest_name" ]; then
        echo -e "  ${YELLOW}↳ [DUPLICATE] '$filename' -> renamed to '$final_dest_name'${NC}"
        log_action "[DUPLICATE RESOLVED] '$filename' renamed to '$final_dest_name' in '$category/'"
    fi

    # Move file to final destination
    mv "$file_path" "$final_dest_path"
    log_action "[MOVED] '$filename' -> '$category/$final_dest_name'"
    echo -e "  ${GREEN}✔ [MOVED]${NC} $filename ${BLUE}➔${NC} $category/$final_dest_name"

    # Increment category-specific counters
    case "$category" in
        "$DIR_IMAGES")
            COUNT_IMAGES=$((COUNT_IMAGES + 1))
            ;;
        "$DIR_DOCS")
            if [ "$ext" = "pdf" ]; then
                COUNT_PDF=$((COUNT_PDF + 1))
            else
                COUNT_DOCS_OTHER=$((COUNT_DOCS_OTHER + 1))
            fi
            ;;
        "$DIR_VIDEOS")
            COUNT_VIDEOS=$((COUNT_VIDEOS + 1))
            ;;
        "$DIR_ARCHIVES")
            if [ "$ext" = "zip" ]; then
                COUNT_ZIP=$((COUNT_ZIP + 1))
            else
                COUNT_ARCHIVES_OTHER=$((COUNT_ARCHIVES_OTHER + 1))
            fi
            ;;
        *)
            COUNT_OTHERS=$((COUNT_OTHERS + 1))
            ;;
    esac

    TOTAL_MOVED=$((TOTAL_MOVED + 1))
done

log_action "Total files moved: $TOTAL_MOVED (Images: $COUNT_IMAGES, PDF: $COUNT_PDF, ZIP: $COUNT_ZIP, Videos: $COUNT_VIDEOS, Other Docs: $COUNT_DOCS_OTHER, Other Archives: $COUNT_ARCHIVES_OTHER, Unknown: $COUNT_OTHERS)"
log_action "================== SESSION END ===================="

# --- Final Summary Report ---
echo ""
echo -e "${BLUE}===================================================${NC}"
echo -e "${BLUE}             Final Organization Report             ${NC}"
echo -e "${BLUE}===================================================${NC}"
echo -e "  • Images (عکس)                 : $COUNT_IMAGES"
echo -e "  • PDF Documents (پی‌دی‌اف)      : $COUNT_PDF"
echo -e "  • ZIP Archives (فایل زیپ)      : $COUNT_ZIP"
echo -e "  • Other Archives (سایر فشرده)  : $COUNT_ARCHIVES_OTHER"
echo -e "  • Videos (ویدیوها)             : $COUNT_VIDEOS"
echo -e "  • Other Documents (سایر اسناد) : $COUNT_DOCS_OTHER"
echo -e "  • Others & Unknown (ناشناخته)  : $COUNT_OTHERS"
echo -e "${BLUE}---------------------------------------------------${NC}"
echo -e "  • Total Files Moved (مجموع)    : ${GREEN}$TOTAL_MOVED${NC}"
echo -e "${BLUE}===================================================${NC}"
echo -e "${GREEN}[INFO] Full activity log saved to: $LOG_FILE${NC}"
echo ""
