#!/bin/bash
# temp_converter.sh - Q8: functions, local variables, echo as return value

# F = (C * 9/5) + 32   -> result is printed with echo and captured by the caller
celsius_to_fahrenheit() {
    local c=$1
    local f
    f=$(awk -v c="$c" 'BEGIN { printf "%.2f", (c * 9 / 5) + 32 }')
    echo "$f"
}

# C = (F - 32) * 5/9
fahrenheit_to_celsius() {
    local f=$1
    local c
    c=$(awk -v f="$f" 'BEGIN { printf "%.2f", (f - 32) * 5 / 9 }')
    echo "$c"
}

# Check that the argument is a number (negative and decimal allowed)
is_number() { [[ "$1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; }

choice=""
while [ "$choice" != "3" ]; do
    echo
    echo "Temperature Converter"
    echo "1. Celsius to Fahrenheit"
    echo "2. Fahrenheit to Celsius"
    echo "3. Exit"
    read -p "Enter choice: " choice || break

    case "$choice" in
        1)
            read -p "Enter temperature in Celsius: " t
            if is_number "$t"; then
                result=$(celsius_to_fahrenheit "$t")
                echo "${t}°C = ${result}°F"
            else
                echo "Error: '$t' is not a valid number." >&2
            fi ;;
        2)
            read -p "Enter temperature in Fahrenheit: " t
            if is_number "$t"; then
                result=$(fahrenheit_to_celsius "$t")
                echo "${t}°F = ${result}°C"
            else
                echo "Error: '$t' is not a valid number." >&2
            fi ;;
        3) echo "Goodbye!" ;;
        *) echo "Invalid choice. Enter 1, 2 or 3." ;;
    esac
done
