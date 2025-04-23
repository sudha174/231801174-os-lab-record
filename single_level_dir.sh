#!/bin/bash

declare -A files
max_files=10

create_file() {
    if [ ${#files[@]} -ge $max_files ]; then
        echo "Directory is full!"
        return
    fi
    echo -n "Enter file name: "
    read fname
    if [[ -v files[$fname] ]]; then
        echo "File already exists!"
    else
        echo -n "Enter file content: "
        read content
        files[$fname]=$content
        echo "File created successfully"
    fi
}

list_files() {
    echo "Files in directory:"
    echo "==================="
    if [ ${#files[@]} -eq 0 ]; then
        echo "Directory is empty"
    else
        for fname in "${!files[@]}"; do
            echo "$fname"
        done
    fi
}

delete_file() {
    echo -n "Enter file name to delete: "
    read fname
    if [[ -v files[$fname] ]]; then
        unset files[$fname]
        echo "File deleted successfully"
    else
        echo "File not found!"
    fi
}

view_file() {
    echo -n "Enter file name to view: "
    read fname
    if [[ -v files[$fname] ]]; then
        echo "Content: ${files[$fname]}"
    else
        echo "File not found!"
    fi
}

while true; do
    echo -e "\nSingle Level Directory Operations"
    echo "1. Create File"
    echo "2. List Files"
    echo "3. Delete File"
    echo "4. View File"
    echo "5. Exit"
    echo -n "Enter choice: "
    read choice

    case $choice in
        1) create_file ;;
        2) list_files ;;
        3) delete_file ;;
        4) view_file ;;
        5) exit 0 ;;
        *) echo "Invalid choice!" ;;
    esac
done