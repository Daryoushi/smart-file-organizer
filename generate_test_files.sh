#!/usr/bin/env bash

# ==============================================================================
# Script Name   : generate_test_files.sh
# Description   : Helper script to generate sample test files for Smart File Organizer
# ==============================================================================

set -euo pipefail

TEST_DIR="${1:-test_folder}"

echo "Creating sample test environment in: '$TEST_DIR'..."
mkdir -p "$TEST_DIR"

# 1. Images
touch "$TEST_DIR/sample1.jpg"
touch "$TEST_DIR/wallpaper.png"
touch "$TEST_DIR/diagram.svg"
touch "$TEST_DIR/photo with spaces.jpeg"

# 2. PDF Documents
touch "$TEST_DIR/linux_book.pdf"
touch "$TEST_DIR/assignment.pdf"

# 3. Other Documents
touch "$TEST_DIR/notes.txt"
touch "$TEST_DIR/project_spec.docx"
touch "$TEST_DIR/dataset.csv"

# 4. Videos
touch "$TEST_DIR/tutorial.mp4"
touch "$TEST_DIR/presentation.mkv"

# 5. Archives (ZIP and others)
touch "$TEST_DIR/archive1.zip"
touch "$TEST_DIR/backup.tar.gz"
touch "$TEST_DIR/package.rar"

# 6. Others / Unknown
touch "$TEST_DIR/README_NO_EXT"
touch "$TEST_DIR/raw_data.bin"

echo "Created 16 sample files in '$TEST_DIR'."
echo "You can now run: ./organizer.sh '$TEST_DIR'"
