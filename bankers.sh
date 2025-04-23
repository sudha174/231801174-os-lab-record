#!/bin/bash

# Input function for matrices
input_matrix() {
    local name=$1
    local rows=$2
    local cols=$3

    echo "Enter $name matrix ($rows x $cols):"
    for ((i=0; i<rows; i++)); do
        echo -n "For process P$i (space-separated): "
        read line
        for ((j=0; j<cols; j++)); do
            val=$(echo $line | cut -d' ' -f$((j+1)))
            eval "$name[$i,$j]=$val"
        done
    done
}

# Function to get value from matrix
get_val() {
    local name=$1
    local i=$2
    local j=$3
    eval echo \${$name[$i,$j]}
}

# Function to calculate Need matrix
calculate_need() {
    for ((i=0; i<n; i++)); do
        for ((j=0; j<m; j++)); do
            max_val=$(get_val max $i $j)
            alloc_val=$(get_val alloc $i $j)
            need[$i,$j]=$((max_val - alloc_val))
        done
    done
}

# Main program starts here
echo -n "Enter number of processes: "
read n
echo -n "Enter number of resources: "
read m

# Get Allocation and Max matrices
declare -A alloc max need
input_matrix "alloc" $n $m
input_matrix "max" $n $m

# Get available resources
declare -a available
echo -n "Enter available resources (space-separated): "
read avail_line
for ((j=0; j<m; j++)); do
    available[$j]=$(echo $avail_line | cut -d' ' -f$((j+1)))
done

# Calculate need matrix
calculate_need

# Initialize finish array and work array
declare -a finish work
for ((i=0; i<n; i++)); do
    finish[$i]=0
done
for ((j=0; j<m; j++)); do
    work[$j]=${available[$j]}
done

# Banker's Algorithm
safe_sequence=()
while true; do
    found=false
    for ((i=0; i<n; i++)); do
        if [[ ${finish[$i]} -eq 0 ]]; then
            can_run=true
            for ((j=0; j<m; j++)); do
                need_val=${need[$i,$j]}
                if (( need_val > work[$j] )); then
                    can_run=false
                    break
                fi
            done

            if $can_run; then
                for ((j=0; j<m; j++)); do
                    work[$j]=$((work[$j] + $(get_val alloc $i $j)))
                done
                finish[$i]=1
                safe_sequence+=("P$i")
                found=true
            fi
        fi
    done

    if ! $found; then
        break
    fi
done

# Check and print result
all_finished=true
for ((i=0; i<n; i++)); do
    if [[ ${finish[$i]} -eq 0 ]]; then
        all_finished=false
        break
    fi
done

echo
if $all_finished; then
    echo "System is in a SAFE state."
    echo -n "Safe sequence: "
    printf "%s " "${safe_sequence[@]}"
    echo
else
    echo "System is NOT in a safe state."
fi
