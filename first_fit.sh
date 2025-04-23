#!/bin/bash

# Function to find first fit block for a process
first_fit() {
    local process_size=$1
    for ((i=0; i<num_blocks; i++)); do
        if [[ ${allocation[$i]} == -1 && ${block_size[$i]} >= $process_size ]]; then
            echo $i
            return
        fi
    done
    echo -1
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

# Allocate memory to processes using First Fit
for ((i=0; i<num_processes; i++)); do
    block_idx=$(first_fit ${process_size[$i]})
    
    if [[ $block_idx != -1 ]]; then
        allocation[$block_idx]=$i
    fi
done

# Calculate and print fragmentation
echo -e "\nMemory Allocation Details:"
echo "Block No.\tSize\t\tProcess No.\tFragmentation"
for ((i=0; i<num_blocks; i++)); do
    echo -n "$i\t\t${block_size[$i]}\t\t"
    if [[ ${allocation[$i]} != -1 ]]; then
        frag=$((block_size[i] - process_size[allocation[i]]))
        echo -n "P${allocation[$i]}\t\t$frag"
    else
        echo -n "Not Allocated\t-"
    fi
    echo
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