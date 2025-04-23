#!/bin/bash

echo -n "Enter the number of processes: "
read n

declare -a burst
declare -a index
declare -a wait
declare -a tat

echo "Enter the burst time of the processes:"
for ((i=0; i<n; i++))
do
    read burst[i]
    index[i]=$i
done

# Sort burst times and keep track of original indices
for ((i=0; i<n-1; i++))
do
    for ((j=i+1; j<n; j++))
    do
        if [ ${burst[i]} -gt ${burst[j]} ]; then
            temp=${burst[i]}
            burst[i]=${burst[j]}
            burst[j]=$temp

            temp=${index[i]}
            index[i]=${index[j]}
            index[j]=$temp
        fi
    done
done

wait[0]=0
tat[0]=${burst[0]}

for ((i=1; i<n; i++))
do
    wait[i]=$((wait[i-1] + burst[i-1]))
    tat[i]=$((wait[i] + burst[i]))
done

total_wait=0
total_tat=0

echo "Process Burst Time Waiting Time Turn Around Time"
for ((i=0; i<n; i++))
do
    # Print original process number (1-based)
    echo "$((index[i]+1)) ${burst[i]} ${wait[i]} ${tat[i]}"
    total_wait=$((total_wait + wait[i]))
    total_tat=$((total_tat + tat[i]))
done

avg_wait=$(echo "scale=1; $total_wait / $n" | bc)
avg_tat=$(echo "scale=1; $total_tat / $n" | bc)

echo "Average waiting time is: $avg_wait"
echo "Average Turn Around Time is: $avg_tat"