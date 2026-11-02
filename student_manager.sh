#!/bin/bash
# student_manager.sh - Q9: indexed and associative arrays

# Indexed array: student names (in the order they were added)
declare -a names=("Ahmed" "Sara" "Mohamed")

# Associative array: ID -> "Name:grade"
declare -A students=(
    [101]="Ahmed:85"
    [102]="Sara:92"
    [103]="Mohamed:78"
)

add_student() {
    local name id grade
    read -p "Student name: " name
    read -p "Student ID: " id
    read -p "Grade (0-100): " grade

    if [ -z "$name" ] || [[ "$name" == *:* ]]; then
        echo "Error: name must be non-empty and must not contain ':'." >&2; return
    fi
    if ! [[ "$id" =~ ^[0-9]+$ ]]; then
        echo "Error: ID must be a number." >&2; return
    fi
    if [ -n "${students[$id]}" ]; then
        echo "Error: ID $id already exists." >&2; return
    fi
    if ! [[ "$grade" =~ ^[0-9]+$ ]] || [ "$grade" -gt 100 ]; then
        echo "Error: grade must be a whole number from 0 to 100." >&2; return
    fi

    names+=("$name")
    students[$id]="$name:$grade"
    echo "Added $name (ID $id, grade $grade)."
}

display_students() {
    if [ "${#students[@]}" -eq 0 ]; then
        echo "No students yet."; return
    fi
    echo "Total students: ${#students[@]}"
    printf "%-6s %-12s %s\n" "ID" "Name" "Grade"
    local id entry
    for id in $(printf '%s\n' "${!students[@]}" | sort -n); do
        entry=${students[$id]}
        printf "%-6s %-12s %s\n" "$id" "${entry%%:*}" "${entry##*:}"
    done
    echo "Names list: ${names[@]}"
}

search_student() {
    local id
    read -p "Enter student ID to search: " id
    if [ -n "${students[$id]}" ]; then
        local entry=${students[$id]}
        echo "Found: ID $id, Name ${entry%%:*}, Grade ${entry##*:}"
    else
        echo "No student with ID '$id'."
    fi
}

average_grade() {
    if [ "${#students[@]}" -eq 0 ]; then
        echo "No students yet."; return
    fi
    local total=0 id
    for id in "${!students[@]}"; do
        total=$((total + ${students[$id]##*:}))
    done
    awk -v t="$total" -v n="${#students[@]}" 'BEGIN { printf "Average grade: %.2f\n", t / n }'
}

choice=""
while [ "$choice" != "5" ]; do
    echo
    echo "===== Student Management ====="
    echo "1. Add a student"
    echo "2. Display all students"
    echo "3. Search for a student by ID"
    echo "4. Calculate average grade"
    echo "5. Exit"
    read -p "Enter choice: " choice || break
    case "$choice" in
        1) add_student ;;
        2) display_students ;;
        3) search_student ;;
        4) average_grade ;;
        5) echo "Goodbye!" ;;
        *) echo "Invalid choice. Enter 1-5." ;;
    esac
done
