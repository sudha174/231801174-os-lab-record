#!/bin/bash

# Prompt the user for two numbers
echo "Enter first number:"
read num1
echo "Enter second number:"
read num2

# Perform arithmetic operations
sum=$(expr $num1 + $num2)
difference=$(expr $num1 - $num2)
product=$(expr $num1 \* $num2)
quotient=$(expr $num1 / $num2)

# Display the results
echo "Sum: $sum"
echo "Difference: $difference"
echo "Product: $product"
echo "Quotient: $quotient"