#!/bin/bash
# system_monitor.sh - Bonus: functions + select menu + getopts + arrays

output_file=""
run_all=false
declare -a results          # array that stores the output of every check

usage() {
    echo "Usage: $0 [-o OUTPUT_FILE] [-a] [-h]"
    echo "  -o FILE  Save the report to FILE"
    echo "  -a       Run all checks automatically (no menu)"
    echo "  -h       Show this help"
}

# Store a result in the array and print it
record() {
    results+=("$1")
    echo "$1"
}

check_cpu() {
    # Sample /proc/stat twice, one second apart, to get real CPU usage
    local u1 n1 s1 i1 w1 q1 sq1 u2 n2 s2 i2 w2 q2 sq2 total idle usage
    read -r _ u1 n1 s1 i1 w1 q1 sq1 _ < /proc/stat
    sleep 1
    read -r _ u2 n2 s2 i2 w2 q2 sq2 _ < /proc/stat
    total=$(( (u2+n2+s2+i2+w2+q2+sq2) - (u1+n1+s1+i1+w1+q1+sq1) ))
    idle=$(( (i2+w2) - (i1+w1) ))
    if [ "$total" -gt 0 ]; then
        usage=$(( 100 * (total - idle) / total ))
    else
        usage=0
    fi
    record "== CPU ==
CPU usage: ${usage}%
Load average: $(cut -d' ' -f1-3 /proc/loadavg)"
}

check_memory() {
    record "== Memory ==
$(free -h)"
}

check_disk() {
    record "== Disk ==
$(df -h / 2>/dev/null)"
}

check_network() {
    local info
    if command -v ip >/dev/null 2>&1; then
        info=$(ip -brief addr 2>/dev/null)
    else
        info=$(hostname -I 2>/dev/null)
    fi
    [ -z "$info" ] && info="No network information available."
    local status="offline"
    if command -v ping >/dev/null 2>&1 && timeout 3 ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
        status="online"
    fi
    record "== Network ==
Internet connectivity: $status
$info"
}

check_processes() {
    record "== Top 5 processes by CPU ==
$(ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6)"
}

run_all_checks() {
    check_cpu; check_memory; check_disk; check_network; check_processes
}

# Print the whole results array
show_report() {
    if [ "${#results[@]}" -eq 0 ]; then
        echo "No results collected yet."
        return
    fi
    echo "===== Report (${#results[@]} sections) ====="
    local item
    for item in "${results[@]}"; do
        echo "$item"
        echo
    done
}

# Write the report to the output file with error handling
save_report() {
    if [ -z "$output_file" ]; then return; fi
    if [ "${#results[@]}" -eq 0 ]; then
        echo "Nothing to save yet."; return
    fi
    {
        echo "System report - $(date)"
        printf '%s\n\n' "${results[@]}"
    } > "$output_file" 2>/dev/null \
        && echo "Report saved to $output_file" \
        || { echo "Error: cannot write to '$output_file'." >&2; return 1; }
}

while getopts ":o:ah" opt; do
    case "$opt" in
        o) output_file="$OPTARG" ;;
        a) run_all=true ;;
        h) usage; exit 0 ;;
        :) echo "Error: option -$OPTARG requires an argument." >&2; usage; exit 1 ;;
        \?) echo "Error: invalid option -$OPTARG" >&2; usage; exit 1 ;;
    esac
done

# Validate output file location before doing any work
if [ -n "$output_file" ]; then
    out_dir=$(dirname "$output_file")
    if [ ! -d "$out_dir" ] || [ ! -w "$out_dir" ]; then
        echo "Error: directory '$out_dir' does not exist or is not writable." >&2
        exit 1
    fi
fi

# -a: run everything and exit
if $run_all; then
    run_all_checks
    echo
    save_report
    exit 0
fi

# Interactive menu using select
PS3="Choose an option: "
options=("CPU" "Memory" "Disk" "Network" "Processes" "All checks" "Show report" "Save report" "Quit")
select opt in "${options[@]}"; do
    case "$opt" in
        "CPU") check_cpu ;;
        "Memory") check_memory ;;
        "Disk") check_disk ;;
        "Network") check_network ;;
        "Processes") check_processes ;;
        "All checks") run_all_checks ;;
        "Show report") show_report ;;
        "Save report")
            if [ -z "$output_file" ]; then
                read -p "Enter output file name: " output_file
            fi
            save_report ;;
        "Quit") echo "Goodbye!"; break ;;
        *) echo "Invalid option '$REPLY'." ;;
    esac
done
