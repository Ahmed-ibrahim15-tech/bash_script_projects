#!/bin/bash
# system_menu.sh - Q3: case statement menu inside a while loop

choice=""
# Loop until the user picks 6 (Exit)
while [ "$choice" != "6" ]; do
    echo
    echo "===== System Menu ====="
    echo "1. Show system date and time"
    echo "2. Display current user"
    echo "3. Show current directory"
    echo "4. List files in current directory"
    echo "5. Display disk usage"
    echo "6. Exit"
    read -p "Enter your choice [1-6]: " choice || break   # stop on end of input

    case "$choice" in
        1) date ;;
        2) whoami ;;
        3) pwd ;;
        4) ls -l ;;
        5) df -h ;;
        6) echo "Goodbye!" ;;
        *) echo "Invalid choice '$choice'. Please enter a number from 1 to 6." ;;
    esac
done
