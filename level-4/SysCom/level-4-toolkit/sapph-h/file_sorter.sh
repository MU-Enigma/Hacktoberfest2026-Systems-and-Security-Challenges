#!/bin/bash
# Usage: ./file_sorter.sh <target_directory>
# Sorts files in <target_directory> into subfolders by extension.

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <target_directory>"
    exit 1
fi

target_dir="$1"

if [[ ! -d "$target_dir" ]]; then
    echo "Error: '$target_dir' is not a directory."
    exit 1
fi

for file in "$target_dir"/*; do
    [[ -f "$file" ]] || continue

    filename="$(basename "$file")"
    extension="${filename##*.}"

    if [[ "$filename" != *.* || "$filename" == .* && "$filename" != *.*.* ]]; then
        folder="misc"
    else
        extension="${extension,,}"

        case "$extension" in
            pdf)
                folder="pdfs"
                ;;
            png|jpg|jpeg|gif|bmp|webp)
                folder="images"
                ;;
            txt|md|doc|docx|odt)
                folder="documents"
                ;;
            sh|bash|py|c|cpp|h|java|js|ts)
                folder="code"
                ;;
            mp3)
                folder="mp3s"
                ;;
            *)
                folder="misc"
                ;;
        esac
    fi

    mkdir -p "$target_dir/$folder"
    mv -- "$file" "$target_dir/$folder/"
done

echo "Files organized successfully."
