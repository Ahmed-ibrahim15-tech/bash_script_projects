#!/bin/bash
# number_operations.sh - Q4: for, while and until loops

echo "=== For Loop ==="
for i in {1..10}; do
    echo -n "$i "
done
echo

echo "=== While Loop ==="
i=1
sum=0
while [ "$i" -le 100 ]; do
    sum=$((sum + i))
    i=$((i + 1))
done
echo "Sum of 1 to 100: $sum"

echo "=== Until Loop ==="
n=2
echo -n "Even numbers: "
until [ "$n" -gt 20 ]; do
    echo -n "$n "
    n=$((n + 2))
done
echo
