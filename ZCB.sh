#!/bin/bash
# version 0.1, Slymaster on Github, 25november2024 
# Default variables
verbose=0
save_file=""
max_columns=5

# Usage function
usage() {
    echo "Usage: $0 [-v] [-s save_file.txt] [users.txt] [archive.zip]"
    echo "-v               : Verbose mode (show tested passwords)"
    echo "-s save_file.txt : Save test details (passwords, time, stats)"
    echo "users.txt        : Input file with user data (optional)"
    echo "archive.zip      : ZIP file to crack (optional)"
    exit 1
}

# Log function for verbosity
log() {
    if [[ $verbose -eq 1 ]]; then
        echo "$1"
    fi
}

# Function to test passwords
crack_zip() {
    local password=$1
    unzip -P "$password" -tq "$zipfile" &>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "Password found: $password"
        [[ -n $save_file ]] && echo "Password found: $password" >> "$save_file"
        exit 0
    fi
}

# Function to generate permutations and save to file
generate_permutations_to_file() {
    local temp_file=$1
    shift
    local elements=("$@")
    local n=${#elements[@]}

    > "$temp_file" # Clear the temporary file
    for ((i = 1; i <= n; i++)); do
        echo "${elements[@]}" | xargs -n $i | awk '{printf "%s\n", $0}' >> "$temp_file"
    done
}

# Process CLI arguments
while getopts "vs:" opt; do
    case $opt in
        v) verbose=1 ;;
        s) save_file=$OPTARG ;;
        *) usage ;;
    esac
done
shift $((OPTIND - 1))

# Get file names
users_file=${1:-}
zipfile=${2:-}

# Interactive prompt if files are not provided
if [[ -z $users_file || -z $zipfile ]]; then
    read -p "What is the name of the file containing user information? " users_file
    read -p "What is the name of the ZIP file to crack? " zipfile
fi

# Check files existence
if [[ ! -f $users_file ]]; then
    echo "Error: User file '$users_file' does not exist."
    exit 1
fi
if [[ ! -f $zipfile ]]; then
    echo "Error: ZIP file '$zipfile' does not exist."
    exit 1
fi

# Initialize save file if specified
if [[ -n $save_file ]]; then
    echo "Save file: $save_file"
    echo "Attempted passwords:" > "$save_file"
fi

# Temporary file for permutations
temp_file=$(mktemp)

# Start processing
echo "Starting brute force..."
while read -r line; do
    # Clean non-alphanumeric characters and split columns
    clean_line=$(echo "$line" | tr -cd '[:alnum:] [:space:]')
    read -a columns <<< "$clean_line"

    # Skip empty lines
    if [[ ${#columns[@]} -eq 0 ]]; then
        echo "Skipping empty line."
        continue
    fi

    # Limit columns to max_columns
    if [[ ${#columns[@]} -gt $max_columns ]]; then
        echo "Warning: Line truncated to $max_columns columns."
        columns=("${columns[@]:0:$max_columns}")
    fi

    # Generate permutations to temporary file
    generate_permutations_to_file "$temp_file" "${columns[@]}"
    log "Generated permutations for: ${columns[*]}"

    # Test each permutation from the temporary file
    while read -r password; do
        log "Testing password: $password"
        crack_zip "$password"
        [[ -n $save_file ]] && echo "$password" >> "$save_file"
    done < "$temp_file"
done < "$users_file"

# Clean up
rm -f "$temp_file"
echo "Password not found. Process completed."
exit 1
