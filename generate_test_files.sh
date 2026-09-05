#!/usr/bin/env bash
set -euo pipefail

TEST_DIR="${1:-test_folder}"

echo "Creating sample test environment in: '$TEST_DIR'..."
mkdir -p "$TEST_DIR"

touch "$TEST_DIR/sample1.jpg"
touch "$TEST_DIR/wallpaper.png"
touch "$TEST_DIR/diagram.svg"
touch "$TEST_DIR/photo with spaces.jpeg"

touch "$TEST_DIR/linux_book.pdf"
touch "$TEST_DIR/assignment.pdf"

touch "$TEST_DIR/notes.txt"
touch "$TEST_DIR/project_spec.docx"
touch "$TEST_DIR/dataset.csv"

touch "$TEST_DIR/tutorial.mp4"
touch "$TEST_DIR/presentation.mkv"

touch "$TEST_DIR/archive1.zip"
touch "$TEST_DIR/backup.tar.gz"
touch "$TEST_DIR/package.rar"

touch "$TEST_DIR/README_NO_EXT"
touch "$TEST_DIR/raw_data.bin"

echo "Created 16 sample files in '$TEST_DIR'."
echo "You can now run: ./organizer.sh '$TEST_DIR'"
