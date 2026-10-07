#!/bin/bash

# Directory to organize
DIR=$1

if [ -z "$DIR" ]; then
    DIR="."
fi

if [ ! -d "$DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi

for file in "$DIR"/*; do

    # Skip directories
    if [ -d "$file" ]; then
        continue
    fi

    filename=$(basename "$file")

    # Get extension
    extension="${filename##*.}"
    extension=$(echo "$extension" | tr '[:upper:]' '[:lower:]')

    # Files without an extension
    if [ "$filename" = "$extension" ]; then
        folder="misc"
    else
        case "$extension" in

            jpg|jpeg|png|gif|bmp|svg|webp)
                folder="images"
                ;;

            mp4|mkv|avi|mov|webm)
                folder="videos"
                ;;

            mp3|wav|flac|ogg|m4a)
                folder="audio"
                ;;

            pdf)
                folder="pdfs"
                ;;

            doc|docx|txt|odt)
                folder="documents"
                ;;

            xls|xlsx|csv|ods)
                folder="spreadsheets"
                ;;

            zip|rar|7z|tar|gz)
                folder="archives"
                ;;

            *)
                folder="misc"
                ;;
        esac
    fi

    # Create folder if it does not exist
    if [ ! -d "$DIR/$folder" ]; then
        mkdir "$DIR/$folder"
    fi

    # Move the file
    if [ -e "$DIR/$folder/$filename" ]; then
        echo "Skipping $filename (already exists)"
    else
        mv "$file" "$DIR/$folder/"
        echo "Moved $filename -> $folder/"
    fi

done

echo "Done!"
