#!/bin/bash

declare -A directories
max_dirs=5
max_files=10

create_dir() {
    if [ ${#directories[@]} -ge $max_dirs ]; then
        echo "Maximum directories reached!"
        return
    fi
    echo -n "Enter directory name: "
    read dirname
    if [[ -v directories[$dirname] ]]; then
        echo "Directory already exists!"
    else
        declare -A files
        directories[$dirname]=files
        echo "Directory created successfully"
    fi
}

create_file() {
    echo -n "Enter directory name: "
    read dirname
    if [[ -v directories[$dirname] ]]; then
        echo -n "Enter file name: "
        read fname
        eval "files=(\${directories[$dirname]})"
        if [[ -v files[$fname] ]]; then
            echo "File already exists!"
        else
            echo -n "Enter file content: "
            read content
            eval "directories[$dirname][$fname]='$content'"
            echo "File created successfully"
        fi
    else
        echo "Directory not found!"
    fi
}

list_structure() {
    echo "Directory Structure:"
    echo "==================="
    for dirname in "${!directories[@]}"; do
        echo "/$dirname"
        eval "declare -A files=(\${directories[$dirname]})"
        for fname in "${!files[@]}"; do
            echo "  |-$fname"
        done
    done
}

delete_file() {
    echo -n "Enter directory name: "
    read dirname
    if [[ -v directories[$dirname] ]]; then
        echo -n "Enter file name: "
        read fname
        eval "unset directories[$dirname][$fname]"
        echo "File deleted successfully"
    else
        echo "Directory not found!"
    fi
}

delete_dir() {
    echo -n "Enter directory name: "
    read dirname
    if [[ -v directories[$dirname] ]]; then
        unset directories[$dirname]
        echo "Directory deleted successfully"
    else
        echo "Directory not found!"
    fi
}

while true; do
    echo -e "\nTwo Level Directory Operations"
    echo "1. Create Directory"
    echo "2. Create File"
    echo "3. List Structure"
    echo "4. Delete File"
    echo "5. Delete Directory"
    echo "6. Exit"
    echo -n "Enter choice: "
    read choice

    case $choice in
        1) create_dir ;;
        2) create_file ;;
        3) list_structure ;;
        4) delete_file ;;
        5) delete_dir ;;
        6) exit 0 ;;
        *) echo "Invalid choice!" ;;
    esac
done