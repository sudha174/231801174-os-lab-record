#!/bin/bash

# Function to find the page that will not be used for the longest time
find_optimal_victim() {
    local current_pos=$1
    local victim_index=0
    local farthest=-1
    
    for ((i=0; i<frame_count; i++)); do
        if [[ ${frames[$i]} == -1 ]]; then
            return $i
        fi
        local next_use=-1
        for ((j=current_pos+1; j<page_count; j++)); do
            if [[ ${frames[$i]} == ${pages[$j]} ]]; then
                next_use=$j
                break
            fi
        done
        if [[ $next_use == -1 ]]; then
            return $i
        fi
        if [[ $next_use > $farthest ]]; then
            farthest=$next_use
            victim_index=$i
        fi
    done
    return $victim_index
}

# Function to check if page exists in frames
page_exists() {
    local page=$1
    for ((i=0; i<frame_count; i++)); do
        if [[ ${frames[$i]} == $page ]]; then
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

# Initialize frames array
declare -a frames
for ((i=0; i<frame_count; i++)); do
    frames[$i]=-1
done

page_faults=0

# Process each page reference
echo -e "\nPage Replacement Process:"
for ((i=0; i<page_count; i++)); do
    current_page=${pages[$i]}
    
    if ! page_exists $current_page; then
        # Page fault occurs
        ((page_faults++))
        
        # Find victim frame
        find_optimal_victim $i
        victim_frame=$?
        frames[$victim_frame]=$current_page
        
        # Print current frame status
        echo -n "Page $current_page -> ["
        for frame in "${frames[@]}"; do
            if [[ $frame == -1 ]]; then
                echo -n " -"
            else
                echo -n " $frame"
            fi
        done
        echo " ] (Page Fault)"
    else
        # Print current frame status (no fault)
        echo -n "Page $current_page -> ["
        for frame in "${frames[@]}"; do
            if [[ $frame == -1 ]]; then
                echo -n " -"
            else
                echo -n " $frame"
            fi
        done
        echo " ] (Hit)"
    fi
done

# Print final statistics
echo -e "\nTotal Page Faults: $page_faults"
hit_ratio=$(echo "scale=2; ($page_count - $page_faults) * 100 / $page_count" | bc)
echo "Hit Ratio: $hit_ratio%"
echo "Miss Ratio: $(echo "scale=2; 100 - $hit_ratio" | bc)%"