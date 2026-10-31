#!/bin/bash
# usage: ./file_sorter.sh <directory>
# sorts files in a folder into subfolders based on extension

targetdir="$1"

if [ -z "$targetdir" ]; then
    targetdir="."
fi

if [ ! -d "$targetdir" ]; then
    echo "folder does not exist: $targetdir"
    exit 1
fi

for file in "$targetdir"/*; do
    # skip subdirectories so we dont mess em up
    if [ -d "$file" ]; then
        continue
    fi

    # make sure file actually exists
    if [ ! -e "$file" ]; then
        continue
    fi

    filename=$(basename "$file")

    # get extension in lowercase
    if [[ "$filename" == *.* ]]; then
        ext="${filename##*.}"
        ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    else
        ext=""
    fi

    # pick folder based on file type
    case "$ext" in
        jpg|jpeg|png|gif|bmp|webp|svg)
            destfolder="images"
            ;;
        mp4|mkv|avi|mov|webm)
            destfolder="videos"
            ;;
        mp3|wav|flac|ogg|m4a)
            destfolder="audio"
            ;;
        pdf)
            destfolder="pdfs"
            ;;
        doc|docx|txt|md|odt|rtf)
            destfolder="documents"
            ;;
        xls|xlsx|csv|ods)
            destfolder="spreadsheets"
            ;;
        zip|tar|gz|bz2|7z|rar)
            destfolder="archives"
            ;;
        sh|py|js|html|css|c|cpp)
            destfolder="code"
            ;;
        *)
            destfolder="misc"
            ;;
    esac

    # create dest folder if it doesnt exist
    mkdir -p "$targetdir/$destfolder"

    targetpath="$targetdir/$destfolder/$filename"

    # move file or skip if already there
    if [ -e "$targetpath" ]; then
        echo "skipping $filename because it already exists in $destfolder"
    else
        mv "$file" "$targetpath"
        echo "moved $filename -> $destfolder/"
    fi
done

echo "done organizing files"
