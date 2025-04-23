#!/bin/bash

# Function to check if a page exists in frames
page_exists() {
    local page=$1
    for frame in "${frames[@]}"; do
        if [[ $frame == $page ]]; then
            return 0
        fi
    done
    return 1
}

# Initialize variables
echo -n "Enter number of frames: "
read frame_count
echo -n "Enter number of pages: "
read page_count
echo -n "Enter page reference string (space-separated): "
read -a pages

# Initialize frames array with -1
declare -a frames
for ((i=0; i<frame_count; i++)); do
    frames[$i]=-1
done

page_faults=0
current_position=0

# Process each page reference
echo -e "\nPage Replacement Process:"
for ((i=0; i<page_count; i++)); do
    current_page=${pages[$i]}
    
    # Check if page exists in frames
    if ! page_exists $current_page; then
        # Page fault occurs
        ((page_faults++))
        
        # Replace page using FIFO
        frames[$current_position]=$current_page
        current_position=$(( (current_position + 1) % frame_count ))
        
        # Print current frame status
        echo -n "Page $current_page -> ["
        for ((j=0; j<frame_count; j++)); do
            if [[ ${frames[$j]} == -1 ]]; then
                echo -n " -"
            else
                echo -n " ${frames[$j]}"
            fi
        done
        echo " ] (Page Fault)"
    else
        # Print current frame status (no fault)
        echo -n "Page $current_page -> ["
        for ((j=0; j<frame_count; j++)); do
            if [[ ${frames[$j]} == -1 ]]; then
                echo -n " -"
            else
                echo -n " ${frames[$j]}"
            fi
        done
        echo " ] (No Fault)"
    fi
done

# Print final statistics
echo -e "\nTotal Page Faults: $page_faults"
hit_ratio=$(echo "scale=2; ($page_count - $page_faults) * 100 / $page_count" | bc)
echo "Hit Ratio: $hit_ratio%"
echo "Miss Ratio: $(echo "scale=2; 100 - $hit_ratio" | bc)%"