# Bash Script Projects

A collection of 11 small Bash scripts that practise core shell-scripting topics: variables, conditionals, loops, `case` menus, functions, arrays, file tests, `getopts` and `select`. Each script is self-contained and has a matching set of test cases.

## Quick start

```bash
chmod +x *.sh          # make the scripts executable (once)
./user_profile.sh      # run any script
./run_tests.sh         # run all automated tests
```

**Requirements:** Bash 4+ (associative arrays), plus standard tools: `awk`, `tar`, `stat`, `find`, `ps`, `free`, `df`. `system_monitor.sh` reads `/proc`, so it is Linux-only.

## Scripts at a glance

| # | Script | Topic | Input |
|---|--------|-------|-------|
| 1 | `user_profile.sh` | Variables, `read`, `$(( ))`, `date` | Interactive |
| 2 | `grade_calculator.sh` | `if / elif / else`, regex validation | Interactive |
| 3 | `system_menu.sh` | `case` inside a `while` loop | Interactive |
| 4 | `number_operations.sh` | `for`, `while`, `until` loops | None |
| 5 | `calculator.sh` | Arithmetic, `++`, `+=` operators | Interactive |
| 6 | `file_info.sh` | Command-line arguments, test operators | `$1` |
| 7 | `checker.sh` | File, string and numeric tests | Interactive |
| 8 | `temp_converter.sh` | Functions, `local`, return via `echo` | Interactive |
| 9 | `student_manager.sh` | Indexed and associative arrays | Interactive |
| 10 | `backup.sh` | `getopts`, `cp`, `tar` | Flags |
| 11 | `system_monitor.sh` | Functions, `select`, `getopts`, arrays | Flags / menu |

---

## Script descriptions

### 1. `user_profile.sh`
Asks for first name, last name and age, then prints a greeting with the calculated birth year (`current year - age`) and the current date/time. Rejects an age that isn't a non-negative whole number.

```
Enter your first name: Ahmed
Enter your last name: Ali
Enter your age: 20
Hello Ahmed Ali, you were born in 2006
Current date and time: 2026-11-02 21:58:00
```

### 2. `grade_calculator.sh`
Reads a score (integers or decimals) and prints a letter grade with a message.

| Score | Grade |
|-------|-------|
| 90–100 | A |
| 80–<90 | B |
| 70–<80 | C |
| 60–<70 | D |
| below 60 | F |

Uses `awk` for the comparisons so decimals like `89.9` work. Rejects non-numbers, negatives and scores above 100.

### 3. `system_menu.sh`
A looping menu: date/time, current user, current directory, `ls -l`, disk usage (`df -h`), or exit. Invalid choices print a message and the menu repeats. It also exits cleanly when input ends (Ctrl+D).

### 4. `number_operations.sh`
Demonstrates the three loop types with no input:
- **for** – prints 1 to 10
- **while** – sums 1 to 100 (result 5050)
- **until** – prints even numbers 2 to 20

### 5. `calculator.sh`
Takes two whole numbers and an operation (add, subtract, multiply, divide, modulus) using `$(( ))`. Division is integer division; dividing by zero or entering non-integers gives an error. Afterwards it runs a bonus demo of `x++`, `x--`, `+=`, `-=`, `*=`, `/=` and `%=`.

### 6. `file_info.sh`
Takes one filename as an argument and reports: type (file / directory / other), readable / writable / executable, size in bytes and last modified time.

Exit codes: `0` success, `1` no argument, `2` file does not exist.

```bash
./file_info.sh /etc/passwd
```

### 7. `checker.sh`
Three demos in one:
1. **File tests** (`-e -f -d -r -w -x`) on a path you enter, plus a count of files and subdirectories if it is a directory.
2. **String tests** (`-z`, `-n`, `=`) on two strings you enter.
3. **Numeric test** (`-eq`, `-gt`) comparing the strings' lengths.

### 8. `temp_converter.sh`
Menu-driven Celsius ↔ Fahrenheit converter. Each conversion is a function that uses a `local` variable and returns its result with `echo`, captured by the caller via `$(...)`. Accepts negative and decimal numbers; output has 2 decimal places.

- `F = C × 9/5 + 32`
- `C = (F − 32) × 5/9`

### 9. `student_manager.sh`
Menu-driven student records using two arrays:
- an **indexed array** `names` (insertion order)
- an **associative array** `students` mapping `ID → "Name:grade"`

Starts with Ahmed (101, 85), Sara (102, 92) and Mohamed (103, 78). Options: add a student, display all (sorted by ID), search by ID, calculate the average, exit. Validation covers duplicate or non-numeric IDs, grades outside 0–100, and names that are empty or contain `:`. Data is kept in memory only, so it resets when the script exits.

### 10. `backup.sh`
Backs up a directory, using `getopts` for options.

```
Usage: ./backup.sh -s SOURCE -d DEST [-c] [-v] [-h]
  -s SOURCE   Source directory (required)
  -d DEST     Destination directory (required, created if missing)
  -c          Compress into a .tar.gz file
  -v          Verbose
  -h          Help
```

Backups are timestamped: `DEST/<name>_YYYYMMDD_HHMMSS` (copy) or `DEST/<name>_YYYYMMDD_HHMMSS.tar.gz` (with `-c`).

```bash
./backup.sh -s ~/Documents -d ~/backups -c -v
```

### 11. `system_monitor.sh`
A system health report. Each check stores its output in a `results` array.

```
Usage: ./system_monitor.sh [-o OUTPUT_FILE] [-a] [-h]
  -o FILE   Save the report to FILE
  -a        Run all checks automatically (no menu)
  -h        Help
```

Checks: **CPU** (usage sampled from `/proc/stat` over 1 second, plus load average), **Memory** (`free -h`), **Disk** (`df -h /`), **Network** (interfaces and an internet ping), **Processes** (top 5 by CPU).

Without `-a` it shows a `select` menu where you can run checks individually, show the collected report, or save it.

```bash
./system_monitor.sh -a -o system_report.txt     # non-interactive
./system_monitor.sh                             # menu
```

---

## Test cases

### Run the automated tests

```bash
./run_tests.sh
```

`run_tests.sh` feeds each script its input, then checks both the **exit code** and the **output text**. It runs in a temporary folder, so it doesn't touch your files. The last line shows the total, for example `Results: 87 passed, 0 failed`. Exit code is 0 only if every test passes.

### Test case table

Inputs are shown as the lines you would type, separated by `↵`.

#### `user_profile.sh`
| Input | Expected result |
|-------|-----------------|
| `Ahmed ↵ Ali ↵ 20` | Greeting with birth year = current year − 20 |
| `Ahmed ↵ Ali ↵ 0` | Birth year = current year |
| `Ahmed ↵ Ali ↵ abc` | Error, exit code 1 |
| `Ahmed ↵ Ali ↵ -5` | Error, exit code 1 |

#### `grade_calculator.sh`
| Input | Expected |
|-------|----------|
| `95`, `90`, `100` | A |
| `89.9` | B |
| `75` | C |
| `60` | D |
| `59`, `0` | F |
| `101` | Error: must be between 0 and 100 |
| `-5`, `abc` | Error: not a valid number |

#### `system_menu.sh`
| Input | Expected |
|-------|----------|
| `2 ↵ 6` | Prints your username, then exits |
| `3 ↵ 6` | Prints the current directory |
| `9 ↵ 6` | "Invalid choice '9'", then exits |
| Ctrl+D | Exits cleanly |

#### `number_operations.sh`
| Input | Expected |
|-------|----------|
| (none) | `1 2 3 ... 10`, `Sum of 1 to 100: 5050`, `Even numbers: 2 4 ... 20` |

#### `calculator.sh`
| Numbers | Operation | Expected |
|---------|-----------|----------|
| 8, 3 | 1 (Add) | `8 + 3 = 11` |
| 8, 3 | 2 (Subtract) | `8 - 3 = 5` |
| 8, 3 | 3 (Multiply) | `8 * 3 = 24` |
| 8, 3 | 4 (Divide) | `8 / 3 = 2` (integer division) |
| 8, 3 | 5 (Modulus) | `8 % 3 = 2` |
| -7, 2 | 1 | `-7 + 2 = -5` |
| 8, 0 | 4 | Error: division by zero |
| 8, 0 | 5 | Error: modulus by zero |
| 8, 3 | 9 | Error: invalid operation |
| `abc`, 3 | – | Error: whole numbers only |
| `2.5`, 3 | – | Error: whole numbers only |
| 5, 2 | 1 | Bonus demo shows `After x++ : 6` |

#### `file_info.sh`
| Command | Expected |
|---------|----------|
| `./file_info.sh` | Usage message, exit 1 |
| `./file_info.sh /nope` | "does not exist", exit 2 |
| `./file_info.sh file.txt` (6 bytes) | Type: regular file, `Size: 6 bytes` |
| `./file_info.sh /tmp` | Type: directory |

#### `checker.sh`
| Path | String 1 | String 2 | Expected |
|------|----------|----------|----------|
| dir with 2 files + 1 subfolder | `hello` | `hello` | `Files: 2`, `Subdirectories: 1`, strings equal |
| same | `hello` | `world` | Strings NOT equal, same length |
| same | `hi` | `hello` | Second string is longer |
| same | `hello` | `hi` | First string is longer |
| same | (empty) | (empty) | First string is empty |
| `/no/such/path` | `a` | `b` | Count is skipped |

#### `temp_converter.sh`
| Choice | Input | Expected |
|--------|-------|----------|
| 1 | `100` | `212.00°F` |
| 1 | `0` | `32.00°F` |
| 1 | `-40` | `-40.00°F` |
| 2 | `212` | `100.00°C` |
| 2 | `98.6` | `37.00°C` |
| 1 | `hot` | Error: not a valid number |
| 7 | – | "Invalid choice" |

#### `student_manager.sh`
| Input | Expected |
|-------|----------|
| `2` | Total students: 3 |
| `4` | Average grade: 85.00 |
| `3 ↵ 102` | Found: ID 102, Name Sara, Grade 92 |
| `3 ↵ 999` | No student with ID '999' |
| `1 ↵ Layla ↵ 104 ↵ 88`, then `2` | Total students: 4 |
| add with ID `101` | Error: ID already exists |
| add with ID `abc` | Error: ID must be a number |
| add with grade `150` | Error: grade must be 0–100 |
| add with name `La:yla` | Error: name must not contain ':' |
| `9` | "Invalid choice" |

#### `backup.sh`
| Command | Expected |
|---------|----------|
| `./backup.sh -h` | Usage text, exit 0 |
| `./backup.sh` | Error: `-s` required, exit 1 |
| `./backup.sh -s src` | Error: `-d` required, exit 1 |
| `./backup.sh -s missing -d out` | Error: does not exist, exit 1 |
| `./backup.sh -x` | Error: invalid option, exit 1 |
| `./backup.sh -s` | Error: requires an argument, exit 1 |
| `./backup.sh -s src -d out` | `out/src_<timestamp>/` with all files, including subfolders |
| `./backup.sh -s src -d out -c` | `out/src_<timestamp>.tar.gz` containing `src/inner/b.txt` |
| `./backup.sh -s src -d out -c -v` | Same, and lists the files |
| `./backup.sh -s src -d new/deep` | Creates `new/deep` first |

#### `system_monitor.sh`
| Command / input | Expected |
|-----------------|----------|
| `-h` | Usage, exit 0 |
| `-z` | Invalid option, exit 1 |
| `-o` (no file) | Requires an argument, exit 1 |
| `-a -o /no/such/dir/r.txt` | Error: directory not writable, exit 1 |
| `-a` | All 5 sections printed |
| `-a -o report.txt` | "Report saved", file has a header and every section |
| Menu: `2` (Memory), `7` (Show report), `9` (Quit) | Report with 1 section |
| Menu: `7`, `9` | "No results collected yet" |

### Trying tests by hand

Interactive scripts can take their input from a pipe, which is how the test runner works:

```bash
printf '95\n' | ./grade_calculator.sh
printf '1\n100\n3\n' | ./temp_converter.sh
printf '2\n5\n' | ./student_manager.sh
```

---

## Other files in this folder

| File | What it is |
|------|------------|
| `report.txt`, `system_report.txt` | Sample output saved by `system_monitor.sh` |
| `test_data/` | Sample folders (`documents`, `photos`) you can use with `backup.sh`, e.g. `./backup.sh -s test_data/documents -d test_data/backup -c` |
| `run_tests.sh` | Automated test runner (see above) |
