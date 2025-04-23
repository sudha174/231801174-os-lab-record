#!/bin/bash

# Function to find least recently used page index
find_lru_index() {
    local min_counter=${counters[0]}
    local min_index=0
    
    for ((i=1; i<frame_count; i++)); do
        if [[ ${counters[$i]} -lt $min_counter ]]; then
            min_counter=${counters[$i]}
            min_index=$i
        fi
    done
    echo $min_index
}

# Function to check if page exists in frames
page_exists() {
    local page=$1
    for ((i=0; i<frame_count; i++)); do
        if [[ ${frames[$i]} == $page ]]; then
            echo $i
            return 0
        fi
    done
    echo -1
    return 1
}

# Initialize variables
echo -n "Enter number of frames: "
read frame_count
echo -n "Enter number of pages: "
read page_count
echo -n "Enter page reference string (space-separated): "
read -a pages

# Initialize arrays
declare -a frames counters
for ((i=0; i<frame_count; i++)); do
    frames[$i]=-1
    counters[$i]=0
done

page_faults=0
current_time=0

# Process each page reference
echo -e "\nPage Replacement Process:"
for ((i=0; i<page_count; i++)); do
    ((current_time++))
    current_page=${pages[$i]}
    
    # Check if page exists
    page_pos=$(page_exists $current_page)
    
    if [ $page_pos -eq -1 ]; then
        # Page fault occurs
        ((page_faults++))
        
        # Find empty frame or LRU page
        empty_found=0
        for ((j=0; j<frame_count; j++)); do
            if [[ ${frames[$j]} == -1 ]]; then
                frames[$j]=$current_page
                counters[$j]=$current_time
                empty_found=1
                break
            fi
        done
        
        # If no empty frame, replace LRU page
        if [ $empty_found -eq 0 ]; then
            lru_index=$(find_lru_index)
            frames[$lru_index]=$current_page
            counters[$lru_index]=$current_time
        fi
        
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
        # Update access time for the page
        counters[$page_pos]=$current_time
        
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