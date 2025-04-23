#!/bin/bash

# Function to find best fit block for a process
best_fit() {
    local process_size=$1
    local best_idx=-1
    local best_size=999999

    for ((i=0; i<num_blocks; i++)); do
        if [[ ${allocation[$i]} == -1 && ${block_size[$i]} >= $process_size ]]; then
            if [[ ${block_size[$i]} < $best_size ]]; then
                best_size=${block_size[$i]}
                best_idx=$i
            fi
        fi
    done
    echo $best_idx
}

# Input number of memory blocks
echo -n "Enter number of memory blocks: "
read num_blocks

# Input sizes of memory blocks
declare -a block_size
echo -n "Enter size of memory blocks (space-separated): "
read blocks
for ((i=0; i<num_blocks; i++)); do
    block_size[$i]=$(echo $blocks | cut -d' ' -f$((i+1)))
done

# Input number of processes
echo -n "Enter number of processes: "
read num_processes

# Input process sizes
declare -a process_size
echo -n "Enter size of processes (space-separated): "
read processes
for ((i=0; i<num_processes; i++)); do
    process_size[$i]=$(echo $processes | cut -d' ' -f$((i+1)))
done

# Initialize allocation array
declare -a allocation
for ((i=0; i<num_blocks; i++)); do
    allocation[$i]=-1
done

# Allocate memory to processes using Best Fit
for ((i=0; i<num_processes; i++)); do
    block_idx=$(best_fit ${process_size[$i]})
    
    if [[ $block_idx != -1 ]]; then
        allocation[$block_idx]=$i
    fi
done

# Print allocation details
echo -e "\nAllocation Details:"
echo "Block No.\tSize\t\tProcess No."
for ((i=0; i<num_blocks; i++)); do
    echo -n "$i\t\t${block_size[$i]}\t\t"
    if [[ ${allocation[$i]} != -1 ]]; then
        echo "P${allocation[$i]}"
    else
        echo "Not Allocated"
    fi
done

# Print unallocated processes
echo -e "\nUnallocated Processes:"
for ((i=0; i<num_processes; i++)); do
    allocated=false
    for ((j=0; j<num_blocks; j++)); do
        if [[ ${allocation[$j]} == $i ]]; then
            allocated=true
            break
        fi
    done
    if ! $allocated; then
        echo "P$i (Size: ${process_size[$i]})"
    fi
done