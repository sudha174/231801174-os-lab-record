#!/bin/bash

echo -n "Enter the number of processes: "
read n

declare -a pname
declare -a burst
declare -a rem_bt
declare -a wait
declare -a tat

for ((i=0; i<n; i++))
do
    echo -n "Enter process name and burst time (space separated): "
    read pname[i] burst[i]
    rem_bt[i]=${burst[i]}
    wait[i]=0
done

echo -n "Enter Time Quantum: "
read quantum

t=0
done_count=0

while [ $done_count -lt $n ]
do
    done_count=0
    for ((i=0; i<n; i++))
    do
        if [ ${rem_bt[i]} -gt 0 ]; then
            if [ ${rem_bt[i]} -gt $quantum ]; then
                t=$((t + quantum))
                rem_bt[i]=$((rem_bt[i] - quantum))
            else
                t=$((t + rem_bt[i]))
                wait[i]=$((t - burst[i]))
                rem_bt[i]=0
            fi
        else
            done_count=$((done_count + 1))
        fi
    done
done

for ((i=0; i<n; i++))
do
    tat[i]=$((burst[i] + wait[i]))
done

total_wait=0
total_tat=0

echo "Process Burst Time Waiting Time Turn Around Time"
for ((i=0; i<n; i++))
do
    echo "${pname[i]} ${burst[i]} ${wait[i]} ${tat[i]}"
    total_wait=$((total_wait + wait[i]))
    total_tat=$((total_tat + tat[i]))
done

avg_wait=$(echo "scale=1; $total_wait / $n" | bc)
avg_tat=$(echo "scale=1; $total_tat / $n" | bc)

echo "Average waiting time is: $avg_wait"
echo "Average Turn Around Time is: $avg_tat"