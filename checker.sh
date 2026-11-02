#!/bin/bash
# checker.sh - Q7: file tests, string tests, numeric tests

read -p "Enter a directory path: " path

# ---- Part 1: file tests ----
echo "--- Checks on '$path' ---"
[ -e "$path" ] && echo "-e exists:       yes" || echo "-e exists:       no"
[ -f "$path" ] && echo "-f regular file: yes" || echo "-f regular file: no"
[ -d "$path" ] && echo "-d directory:    yes" || echo "-d directory:    no"
[ -r "$path" ] && echo "-r readable:     yes" || echo "-r readable:     no"
[ -w "$path" ] && echo "-w writable:     yes" || echo "-w writable:     no"
[ -x "$path" ] && echo "-x executable:   yes" || echo "-x executable:   no"

if [ -d "$path" ]; then
    # Count only direct children
    files=$(find "$path" -mindepth 1 -maxdepth 1 -type f 2>/dev/null | wc -l)
    dirs=$(find "$path" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    echo "Files: $files"
    echo "Subdirectories: $dirs"
else
    echo "'$path' is not a directory (or does not exist), skipping the count."
fi

# ---- Part 2: string tests ----
echo
read -p "Enter first string: " s1
read -p "Enter second string: " s2

[ -z "$s1" ] && echo "-z: first string is empty"     || echo "-n: first string is non-empty"
[ -z "$s2" ] && echo "-z: second string is empty"    || echo "-n: second string is non-empty"
[ -n "$s1" ] && echo "-n check on first string: true"  || echo "-n check on first string: false"

if [ "$s1" = "$s2" ]; then
    echo "The strings are equal (=)."
else
    echo "The strings are NOT equal (!=)."
fi

# ---- Part 3: numeric comparison (-eq) using string lengths ----
len1=${#s1}
len2=${#s2}
echo "Length 1 = $len1, Length 2 = $len2"
if [ "$len1" -eq "$len2" ]; then
    echo "Both strings have the same length (-eq)."
elif [ "$len1" -gt "$len2" ]; then
    echo "The first string is longer (-gt)."
else
    echo "The second string is longer (-lt)."
fi
