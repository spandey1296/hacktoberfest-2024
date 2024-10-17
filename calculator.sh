#!/bin/bash

# Function to perform basic arithmetic operations
function calculate() {
  case "$operation" in
    +)
      result=$(($operand1 + $operand2))
      ;;
    -)
      result=$(($operand1 - $operand2))
      ;;
    *)
      result=$(($operand1 * $operand2))
      ;;
    /)
      if [[ $operand2 -eq 0 ]]; then
        echo "Error: Division by zero is not allowed."
        return 1
      fi
      result=$(($operand1 / $operand2))
      ;;
    %)
      result=$(($operand1 % $operand2))
      ;;
    *)
      echo "Invalid operation. Please choose +, -, *, /, or %."
      return 1
      ;;
  esac

  echo "Result: $result"
}

# Main loop to continuously prompt for input
while true; do
  echo "Enter the first operand:"
  read operand1

  echo "Enter the operation (+, -, *, /, %):"
  read operation

  echo "Enter the second operand:"
  read operand2

  calculate

  echo "Do you want to perform another calculation? (y/n)"
  read answer

  if [[ $answer != "y" ]]; then
    break
  fi
done
