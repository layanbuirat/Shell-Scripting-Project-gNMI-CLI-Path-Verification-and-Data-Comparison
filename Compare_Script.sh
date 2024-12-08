#!/bin/bash

# Input: gNMI and CLI output files
GNMI_FILE=$1
CLI_FILE=$2

# Check if both input files are provided
if [[ -z "$GNMI_FILE" || -z "$CLI_FILE" ]]; then
    echo "Usage: $0 <GNMI_Output_File> <CLI_Output_File>"
    exit 1
fi

# Check if the files exist
if [[ ! -f "$GNMI_FILE" ]]; then
    echo "Error: $GNMI_FILE not found."
    exit 1
fi

if [[ ! -f "$CLI_FILE" ]]; then
    echo "Error: $CLI_FILE not found."
    exit 1
fi

# Function to normalize case and remove special characters
normalize_key() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]-_$'
}

# Function to convert units
convert_units() {
    value="$1"
    if [[ $value == *G ]]; then
        echo $(( ${value%G} * 1000000000 )) # Convert G to base (e.g., bytes)
    elif [[ $value == *GB ]]; then
        echo $(( ${value%GB} * 1000000000 )) # Convert GB to base (e.g., bytes)
    elif [[ $value == *M ]]; then
        echo $(( ${value%M} * 1000000 )) # Convert M to base (e.g., bytes)
    elif [[ $value == *MB ]]; then
        echo $(( ${value%MB} * 1000000 )) # Convert MB to base (e.g., bytes)
    elif [[ $value == *K ]]; then
        echo $(( ${value%K} * 1000 )) # Convert K to base (e.g., bytes)
    elif [[ $value == *KB ]]; then
        echo $(( ${value%KB} * 1024 )) # Convert KB to base (e.g., bytes)
    elif [[ $value == *T ]]; then
        echo $(( ${value%T} * 1000000000000 )) # Convert T to base (e.g., bytes)
    elif [[ $value == *TB ]]; then
        echo $(( ${value%TB} * 1000000000000 )) # Convert TB to base (e.g., bytes)
    elif [[ $value == *% ]]; then
        # Remove percentage symbol and handle precision
        percent_value="${value%%%}"
        if [[ $percent_value == *\.00 ]]; then
            percent_value="${percent_value%\.*}"
        fi
        echo "$percent_value%"
    else
        echo "$value"
    fi
}

# Function to handle decimals
adjust_precision() {
    printf "%.2f" "$1" | sed 's/\.00$//' # Round to 2 decimal places and remove trailing .00
}

# Parse GNMI output
declare -A GNMI_DATA
while IFS=": " read -r key value; do
    if [[ $key && $value ]]; then
        clean_key=$(normalize_key "$key")
        clean_value=$(convert_units "$(echo "$value" | tr -d '",{} ')")
        GNMI_DATA["$clean_key"]="$clean_value"
    fi
done < <(jq -r 'to_entries[] | "\(.key): \(.value)"' "$GNMI_FILE")

# Parse CLI output
declare -A CLI_DATA
while IFS=": " read -r key value; do
    if [[ $key && $value ]]; then
        clean_key=$(normalize_key "$key")
        clean_value=$(convert_units "$(echo "$value" | tr -d '",{} ')")
        CLI_DATA["$clean_key"]="$clean_value"
    fi
done < <(grep ':' "$CLI_FILE")

# Start comparison
discrepancies_found=false

# Compare GNMI vs CLI
for key in "${!GNMI_DATA[@]}"; do
    gnmi_value=${GNMI_DATA[$key]}
    if [[ ! -v CLI_DATA["$key"] ]]; then
        echo "$key appears in the gNMI output but is missing in the CLI output."
        discrepancies_found=true
    else
        cli_value=${CLI_DATA[$key]}
        if [[ "$gnmi_value" != "$cli_value" ]]; then
            if [[ $gnmi_value =~ ^[0-9]+\.0$ && $cli_value =~ ^[0-9]+$ ]]; then
                gnmi_value="${gnmi_value%\.0}"
            elif [[ $cli_value =~ ^[0-9]+\.0$ && $gnmi_value =~ ^[0-9]+$ ]]; then
                cli_value="${cli_value%\.0}"
            elif [[ $gnmi_value =~ ^[0-9]+\.[0-9]+%$ && $cli_value =~ ^[0-9]+%$ ]]; then
                gnmi_value="${gnmi_value%\.*}"
            elif [[ $cli_value =~ ^[0-9]+\.[0-9]+%$ && $gnmi_value =~ ^[0-9]+%$ ]]; then
                cli_value="${cli_value%\.*}"
            fi
            if [[ "$gnmi_value" != "$cli_value" ]]; then
                echo "$key differs between gNMI ($gnmi_value) and CLI ($cli_value) outputs."
                discrepancies_found=true
            fi
        fi
    fi
done

# Check for values in CLI missing in GNMI
for key in "${!CLI_DATA[@]}"; do
    if [[ ! -v GNMI_DATA["$key"] ]]; then
        echo "$key appears in the CLI output but is missing in the gNMI output."
        discrepancies_found=true
    fi
done

# Print message if no discrepancies found
if ! $discrepancies_found; then
    echo "All values match; no discrepancies."
fi
