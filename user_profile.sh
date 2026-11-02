#!/bin/bash
# user_profile.sh - Q1: Variables and user input

# Prompt the user (read -p shows the prompt text) and store answers in variables
read -p "Enter your first name: " first_name
read -p "Enter your last name: " last_name
read -p "Enter your age: " age

# Validate age: must be a whole number
if ! [[ "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must be a non-negative whole number." >&2
    exit 1
fi

# Current year from date, then arithmetic expansion for the birth year
current_year=$(date +%Y)
birth_year=$((current_year - age))

# Store current date and time in a variable
now=$(date "+%Y-%m-%d %H:%M:%S")

# ${} syntax keeps variable names separate from surrounding text
echo "Hello ${first_name} ${last_name}, you were born in ${birth_year}"
echo "Current date and time: ${now}"
