#!/bin/bash

echo -n "Enter the number of processes: "
read n

declare -a pname
declare -a burst
declare -a priority
declare -a wait
declare -a tat

for ((i=0; i<n; i++))
do
    echo -n "Enter process name, burst time, and priority (space separated): "
    read pname[i] burst[i] priority[i]
done

# Sort by priority (lower number = higher priority)
for ((i=0; i<n-1; i++))
do
    for ((j=i+1; j<n; j++))
    do
        if [ ${priority[i]} -gt ${priority[j]} ]; then
            # Swap priority
            temp=${priority[i]}
            priority[i]=${priority[j]}
            priority[j]=$temp
            # Swap burst
            temp=${burst[i]}
            burst[i]=${burst[j]}
            burst[j]=$temp
            # Swap pname
            temp=${pname[i]}
            pname[i]=${pname[j]}
            pname[j]=$temp
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

echo "Process Burst Time Priority Waiting Time Turn Around Time"
for ((i=0; i<n; i++))
do
    echo "${pname[i]} ${burst[i]} ${priority[i]} ${wait[i]} ${tat[i]}"
    total_wait=$((total_wait + wait[i]))
    total_tat=$((total_tat + tat[i]))
done

avg_wait=$(echo "scale=1; $total_wait / $n" | bc)
avg_tat=$(echo "scale=1; $total_tat / $n" | bc)

echo "Average waiting time is: $avg_wait"
echo "Average Turn around Time is: $avg_tat"