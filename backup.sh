#!/bin/bash
# backup.sh - Q10: getopts backup script

usage() {
    echo "Usage: $0 -s SOURCE -d DEST [-c] [-v] [-h]"
    echo "  -s SOURCE  Source directory to back up (required)"
    echo "  -d DEST    Destination directory (required)"
    echo "  -c         Compress the backup into a tar.gz file"
    echo "  -v         Verbose: show files being copied"
    echo "  -h         Show this help"
}

source_dir=""
dest_dir=""
compress=false
verbose=false

# Leading ':' = silent mode, so we print our own error messages
while getopts ":s:d:cvh" opt; do
    case "$opt" in
        s) source_dir="$OPTARG" ;;
        d) dest_dir="$OPTARG" ;;
        c) compress=true ;;
        v) verbose=true ;;
        h) usage; exit 0 ;;
        :) echo "Error: option -$OPTARG requires an argument." >&2; usage; exit 1 ;;
        \?) echo "Error: invalid option -$OPTARG" >&2; usage; exit 1 ;;
    esac
done

# Both -s and -d are required
if [ -z "$source_dir" ]; then
    echo "Error: Source directory (-s) is required" >&2
    usage; exit 1
fi
if [ -z "$dest_dir" ]; then
    echo "Error: Destination directory (-d) is required" >&2
    usage; exit 1
fi

# Source must exist and be a directory
if [ ! -d "$source_dir" ]; then
    echo "Error: Source directory '$source_dir' does not exist." >&2
    exit 1
fi

# Create destination if needed
if [ ! -d "$dest_dir" ]; then
    mkdir -p "$dest_dir" || { echo "Error: cannot create '$dest_dir'." >&2; exit 1; }
    echo "Created destination directory: $dest_dir"
fi

timestamp=$(date +%Y%m%d_%H%M%S)
base=$(basename "$(realpath "$source_dir")")

if $compress; then
    archive="$dest_dir/${base}_${timestamp}.tar.gz"
    if $verbose; then tar_flags="-czvf"; else tar_flags="-czf"; fi
    tar $tar_flags "$archive" -C "$(dirname "$(realpath "$source_dir")")" "$base" \
        || { echo "Error: compression failed." >&2; exit 1; }
    echo "Compressed backup created: $archive"
else
    target="$dest_dir/${base}_${timestamp}"
    if $verbose; then cp_flags="-rv"; else cp_flags="-r"; fi
    cp $cp_flags "$source_dir" "$target" \
        || { echo "Error: copy failed." >&2; exit 1; }
    echo "Backup copied to: $target"
fi
