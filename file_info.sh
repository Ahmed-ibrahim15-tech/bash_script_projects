#!/bin/bash
# file_info.sh - Q6: command-line arguments and test operators

echo "Number of arguments received: $#"

# No argument -> usage
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    echo "Example: $0 /etc/passwd"
    exit 1
fi

file="$1"

# Does it exist?
if [ ! -e "$file" ]; then
    echo "Error: '$file' does not exist." >&2
    exit 2
fi

echo "File: $file"

# Type
if [ -d "$file" ]; then
    echo "Type: directory"
elif [ -f "$file" ]; then
    echo "Type: regular file"
else
    echo "Type: other (link, device, etc.)"
fi

# Permissions for the current user
[ -r "$file" ] && echo "Readable:   yes" || echo "Readable:   no"
[ -w "$file" ] && echo "Writable:   yes" || echo "Writable:   no"
[ -x "$file" ] && echo "Executable: yes" || echo "Executable: no"

# Size and modification time
echo "Size: $(stat -c %s "$file") bytes"
echo "Last modified: $(stat -c %y "$file")"
