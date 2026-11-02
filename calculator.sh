#!/bin/bash
# calculator.sh - Q5: arithmetic with $(( ))

read -p "Enter first number: " a
read -p "Enter second number: " b

# $(( )) only handles integers, so validate input
int_re='^-?[0-9]+$'
if ! [[ "$a" =~ $int_re && "$b" =~ $int_re ]]; then
    echo "Error: please enter whole numbers only." >&2
    exit 1
fi

echo
echo "Operations:"
echo "1. Add"
echo "2. Subtract"
echo "3. Multiply"
echo "4. Divide"
echo "5. Modulus"
read -p "Choose an operation [1-5]: " op

case "$op" in
    1) echo "$a + $b = $((a + b))" ;;
    2) echo "$a - $b = $((a - b))" ;;
    3) echo "$a * $b = $((a * b))" ;;
    4)
        if [ "$b" -eq 0 ]; then
            echo "Error: division by zero is not allowed." >&2
            exit 1
        fi
        echo "$a / $b = $((a / b)) (integer division)" ;;
    5)
        if [ "$b" -eq 0 ]; then
            echo "Error: modulus by zero is not allowed." >&2
            exit 1
        fi
        echo "$a % $b = $((a % b))" ;;
    *) echo "Error: invalid operation '$op'." >&2; exit 1 ;;
esac

# ---- Bonus: increment, decrement and compound assignment ----
echo
echo "--- Bonus demos (starting with x=$a) ---"
x=$a
((x++)); echo "After x++ : $x"
((x--)); echo "After x-- : $x"
((x += 5)); echo "After x += 5 : $x"
((x -= 2)); echo "After x -= 2 : $x"
((x *= 3)); echo "After x *= 3 : $x"
if [ "$b" -ne 0 ]; then
    ((x /= b)); echo "After x /= $b : $x"
    ((x %= b)); echo "After x %= $b : $x"
fi
