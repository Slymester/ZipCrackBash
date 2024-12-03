#!/bin/bash

# Colors for summary
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NC="\033[0m" # No Color

# Variables for statistics
start_time=$(date +%s)
attempts=0
success=false
log_file=""
verbose=false
debug=false
found_password=""

# Function to display help
display_help() {
    echo "Usage: $0 -t <input_file.txt> -z <archive.zip> [-o <log_file>] [-v] [-d] [-h]"
    echo "Options:"
    echo "  -t    Input text file containing words (max 5 words per line)."
    echo "  -z    Target ZIP archive to crack."
    echo "  -o    Output log file to store the results (optional)."
    echo "  -v    Enable verbose mode for additional output."
    echo "  -d    Enable debug mode for detailed logs."
    echo "  -h    Display this help message."
    exit 0
}

# Function to show an introductory message
intro_message() {
    echo -e "-------------------------------------------------------------"
    echo -e "${CYAN}Welcome to the ZipCrackBash a password cracker for zip protected !${NC}"
    echo -e "${CYAN}This script will attempt to crack a ZIP file by testing permutations of words from an input file.${NC}"
    echo -e "${CYAN}Usage:${NC} Provide a text file where each line contains up to 5 words separated by spaces."
    echo -e "${CYAN}Example of input file:${NC}"
    echo -e "${YELLOW}Alice Bob 1990${NC}       (First name, last name, and a year)"
    echo -e "${YELLOW}John Doe Password123${NC}  (First name, last name, and a custom word)"
    echo -e "${YELLOW}Emma Code 2024 42${NC}     (First name, a keyword, and numeric values)"
    echo -e "${CYAN}Options available:${NC} Use -t for the input file, -z for the target ZIP file, and other options for logging and verbosity."
    echo -e "--------------------------------------------------------------"
}

# Show intro message
intro_message

# Check arguments
if [ $# -lt 2 ]; then
    echo -e "${YELLOW}Interactive mode: Missing arguments.${NC}"
    read -p "What is the name of the file containing user information? [users.txt]: " input_file
    input_file=${input_file:-users.txt}
    read -p "What is the name of the file for brute force? [archive.zip]: " zip_file
    zip_file=${zip_file:-archive.zip}
else
    input_file=$1
    zip_file=$2
fi

# Parse arguments
while getopts ":t:z:o:vdh" opt; do
    case $opt in
        t) input_file="$OPTARG" ;;
        z) zip_file="$OPTARG" ;;
        o) log_file="$OPTARG" ;;
        v) verbose=true ;;
        d) debug=true ;;
        h) display_help ;;
        *) echo -e "${RED}Invalid option: -$OPTARG${NC}" && display_help ;;
    esac
done

# Validate inputs
if [[ -z "$input_file" || -z "$zip_file" ]]; then
    echo -e "${RED}Error: Input file (-t) and ZIP file (-z) are required.${NC}"
    display_help
fi

if [[ ! -f "$input_file" ]]; then
    echo -e "${RED}Error: Input file '$input_file' does not exist.${NC}"
    exit 1
fi

if [[ ! -f "$zip_file" ]]; then
    echo -e "${RED}Error: ZIP file '$zip_file' does not exist.${NC}"
    exit 1
fi

# Prepare log file
if [[ -n "$log_file" ]]; then
    mkdir -p zcb_logs
    log_file="zcb_logs/$log_file"
    > "$log_file"
    echo "Log file: $log_file" | tee -a "$log_file"
else
    echo -e "${RED}Error: Failed to create log file '$log_file'. Check permissions.${NC}"
    exit 1
fi

# Function to log messages
log_message() {
    local message="$1"
    [[ $verbose == true ]] && echo -e "$message"
    [[ -n $log_file ]] && echo "$message" >> "$log_file"
}

# Function to handle extraction after password is found
handle_extraction() {
    local password="$1"
    while true; do
        read -p "Password found. Do you want to extract the files to zcb_logs? (y/n): " confirm
        case $confirm in
            [Yy]* )
                # Extraction dans zcb_logs
                mkdir -p zcb_logs  # Ensure the directory exists
                unzip -P "$password" "$zip_file" -d "zcb_logs" &>> "$log_file"
                echo -e "${GREEN}Files extracted to: zcb_logs${NC}" | tee -a "$log_file"
                echo -e "${GREEN}Extracted object: $(basename "$zip_file")${NC}" | tee -a "$log_file"
                return 0
                ;;
            [Nn]* )
                echo -e "${YELLOW}Extraction cancelled by user.${NC}" | tee -a "$log_file"
                return 1
                ;;
            * )
                # Si l'entrée est invalide, demande une réponse valide
                echo -e "${RED}Invalid input. Please answer y or n.${NC}"
                ;;
        esac
    done
}

# Function to test password
test_password() {
    local password="$1"
    attempts=$((attempts + 1))
    if unzip -P "$password" -tq "$zip_file" &>/dev/null; then
        success=true
        found_password="$password"
        echo -e "${GREEN}Password found: $password${NC}" | tee -a "$log_file"
        return 0
    fi
    return 1
}

# Function to generate permutations
generate_permutations() {
    local elements=("$@")
    local temp_file="temp_results.txt"
    > "$temp_file"

    # Permutations with 1 element
    for ((i=0; i<${#elements[@]}; i++)); do
        echo "${elements[i]}" >> "$temp_file"
    done
    if [[ ${#elements[@]} -gt 1 ]]; then
        # Permutations with 2 elements
        for ((i=0; i<${#elements[@]}; i++)); do
            for ((j=0; j<${#elements[@]}; j++)); do
                if [[ $i -ne $j ]]; then
                    echo "${elements[i]}${elements[j]}" >> "$temp_file"
                fi
            done
        done
    fi
    if [[ ${#elements[@]} -gt 2 ]]; then
        # Permutations with 3 elements
        for ((i=0; i<${#elements[@]}; i++)); do
            for ((j=0; j<${#elements[@]}; j++)); do
                for ((k=0; k<${#elements[@]}; k++)); do
                    if [[ $i -ne $j && $i -ne $k && $j -ne $k ]]; then
                        echo "${elements[i]}${elements[j]}${elements[k]}" >> "$temp_file"
                    fi
                done
            done
        done
    fi
    if [[ ${#elements[@]} -gt 3 ]]; then
        # Permutations with 4 elements
        for ((i=0; i<${#elements[@]}; i++)); do
            for ((j=0; j<${#elements[@]}; j++)); do
                for ((k=0; k<${#elements[@]}; k++)); do
                    for ((l=0; l<${#elements[@]}; l++)); do
                        if [[ $i -ne $j && $j -ne $k && $k -ne $l && $i -ne $l ]]; then
                            echo "${elements[i]}${elements[j]}${elements[k]}${elements[l]}" >> "$temp_file"
                        fi
                    done
                done
            done
        done
    fi
    if [[ ${#elements[@]} -gt 4 ]]; then
        # Permutations with 5 elements
        for ((i=0; i<${#elements[@]}; i++)); do
            for ((j=0; j<${#elements[@]}; j++)); do
                for ((k=0; k<${#elements[@]}; k++)); do
                    for ((l=0; l<${#elements[@]}; l++)); do
                        for ((m=0; m<${#elements[@]}; m++)); do
                            if [[ $i -ne $j && $j -ne $k && $k -ne $l && $l -ne $m && $i -ne $m ]]; then
                                echo "${elements[i]}${elements[j]}${elements[k]}${elements[l]}${elements[m]}" >> "$temp_file"
                            fi
                        done
                    done
                done
            done
        done
    fi
    cat "$temp_file"
    rm "$temp_file"
}

# Read input file and process lines
while IFS= read -r line; do
    [[ $debug == true ]] && log_message "${YELLOW}Debug: Processing line: $line${NC}"
    words=($line)
    if [[ ${#words[@]} -gt 5 ]]; then
        log_message "${RED}Skipping line (more than 5 words): $line${NC}"
        continue
    fi

    # Generate permutations and test each password
    permutations=$(generate_permutations "${words[@]}")
    while IFS= read -r password; do
        log_message "${YELLOW}Testing password: $password${NC}"
        test_password "$password"
        if [[ $success == true ]]; then
            break
        fi
    done <<< "$permutations"
    if [[ $success == true ]]; then
        break
    fi
done < "$input_file"

# Display summary
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
if [[ $success == false ]]; then
    echo -e "${RED}No password found.${NC}" | tee -a "$log_file"
else
    handle_extraction "$found_password"
fi
echo -e "${YELLOW}Summary:${NC}"
echo -e "${YELLOW}Total attempts: $attempts${NC}"
echo -e "${YELLOW}Elapsed time: ${elapsed_time}s${NC}" | tee -a "$log_file"