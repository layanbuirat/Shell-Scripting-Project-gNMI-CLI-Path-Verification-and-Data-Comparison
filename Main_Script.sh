#!/bin/bash

# Input: GNMI Path
GNMI_PATH=$1

# Check if a path is provided
if [ -z "$GNMI_PATH" ]; then
    echo "Usage: $0 <GNMI_PATH>"
    exit 1
fi

# Define output files
GNMI_OUTPUT_FILE="GNMI_Output.json"
CLI_OUTPUT_FILE="CLI_Output.txt"

# Step 1: Call GNMI_Script.sh
echo
echo "Running GNMI_Script.sh with path: $GNMI_PATH"
./GNMI_Script.sh "$GNMI_PATH"

# Check if the GNMI output file was created successfully
if [ -f "$GNMI_OUTPUT_FILE" ]; then
    echo
    echo "GNMI output saved to $GNMI_OUTPUT_FILE."
else
    echo
    echo "Error: GNMI_Script.sh did not generate $GNMI_OUTPUT_FILE."
    exit 1
fi

# Step 2: Call CLI_Command_Script.sh
echo
echo "-------------------------------------------------------------------------------"
echo
echo "Running CLI_Command_Script.sh with path: $GNMI_PATH"
./CLI_Command_Script.sh "$GNMI_PATH"

# Check if the CLI output file was created successfully
if [ -f "$CLI_OUTPUT_FILE" ]; then
    echo
    echo "CLI output saved to $CLI_OUTPUT_FILE."
else
    echo
    echo "Error: CLI_Command_Script.sh did not generate $CLI_OUTPUT_FILE."
    exit 1
fi

echo "-------------------------------------------------------------------------------"
echo
./Compare_Script.sh "$GNMI_OUTPUT_FILE" "$CLI_OUTPUT_FILE"
