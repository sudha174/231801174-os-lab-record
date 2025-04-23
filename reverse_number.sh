#!/bin/bash

echo "Enter a number:"
read num

reverse=0
while [ $num -gt 0 ]
do
    rem=$(expr $num % 10)
    reverse=$(expr $reverse \* 10 + $rem)
    num=$(expr $num / 10)
done

echo "Reversed number: $reverse"