#!/bin/bash
# grade_calculator.sh - Q2: if-elif-else grade calculator

read -p "Enter your score: " score

# Validate: integer or decimal number (no letters, no negatives)
if ! [[ "$score" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: '$score' is not a valid number." >&2
    exit 1
fi

# Helper: ge VALUE -> true if score >= VALUE (awk handles decimals)
ge() { awk -v s="$score" -v v="$1" 'BEGIN { exit !(s >= v) }'; }

# Range check 0-100
if ! ge 0 || ge 100.0000001; then
    echo "Error: score must be between 0 and 100." >&2
    exit 1
fi

# Assign the letter grade with if-elif-else
if ge 90; then
    grade="A"; msg="Excellent work!"
elif ge 80; then
    grade="B"; msg="Good job!"
elif ge 70; then
    grade="C"; msg="Not bad, keep going."
elif ge 60; then
    grade="D"; msg="You passed, but try to improve."
else
    grade="F"; msg="Please study more and try again."
fi

echo "Your grade is: $grade"
echo "$msg"
