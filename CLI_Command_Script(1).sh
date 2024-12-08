#!/bin/bash

# Input: GNMI Path
GNMI_PATH=$1

# Check if a path is provided
if [ -z "$GNMI_PATH" ]; then
    echo "Usage: $0 <GNMI_PATH>"
    exit 1
fi

# Output file
OUTPUT_FILE="CLI_Output.txt"
# Clear the output file to start fresh
> CLI_Output.txt

# Define a main dictionary to classify paths (single vs multi commands)
declare -A PATH_TYPE

# Define single-command paths
declare -A Single_Command
Single_Command["/interfaces/interface[name=eth0]/state/counters"]="show interfaces eth0 counters"
Single_Command["/system/memory/state"]="show memory"
Single_Command["/interfaces/interface[name=eth1]/state/counters"]="show interfaces eth1 counters"
Single_Command["/system/cpu/state/usage"]="show cpu"
Single_Command["/routing/protocols/protocol[ospf]/ospf/state"]="show ospf status"

# Define multi-command paths
declare -A Multi_Commands
# Define multi-command paths (store commands as a single string separated by semicolons)
declare -A Multi_Commands
Multi_Commands["/interfaces/interface[name=eth0]/state"]="show interfaces eth0 status;show interfaces eth0 mac-address;show interfaces eth0 mtu;show interfaces eth0 speed"
Multi_Commands["/bgp/neighbors/neighbor[neighbor_address=10.0.0.1]/state"]="show bgp neighbors 10.0.0.1;show bgp neighbors 10.0.0.1 received-routes;show bgp neighbors 10.0.0.1 advertised-routes"
Multi_Commands["/system/cpu/state"]="show cpu usage;show cpu user;show cpu system;show cpu idle"
Multi_Commands["/ospf/areas/area[id=0.0.0.0]/state"]="show ospf area 0.0.0.0;show ospf neighbors"
Multi_Commands["/system/disk/state"]="show disk space;show disk health"


# Populate PATH_TYPE dictionary: classify paths as single or multi-command
for path in "${!Single_Command[@]}"; do
    PATH_TYPE["$path"]="single"
done
for path in "${!Multi_Commands[@]}"; do
    PATH_TYPE["$path"]="multi"
done

# Check if the provided path exists
if [[ -v PATH_TYPE["$GNMI_PATH"] ]]; then
    if [[ "${PATH_TYPE[$GNMI_PATH]}" == "single" ]]; then
        # Execute single CLI command
        CLI_CMD="${Single_Command[$GNMI_PATH]}"
        echo
        echo "GNMI Path: $GNMI_PATH"
        echo "CLI Command: $CLI_CMD"
        echo "CLI Output"
        
        # Call CLI_OUTPUT.sh to execute the command and save the result in CLI_Output.txt
        ./CLI_OUTPUT_Script.sh "$CLI_CMD"
        echo "The CLI commands output saved to '$OUTPUT_FILE'"
        echo
        
    elif [[ "${PATH_TYPE[$GNMI_PATH]}" == "multi" ]]; then
        
        # Split the commands using semicolon and execute each command
        IFS=';' read -ra COMMANDS <<< "${Multi_Commands[$GNMI_PATH]}"
        echo
        echo "GNMI Path: $GNMI_PATH"
        echo
        for CMD in "${COMMANDS[@]}"; do
            echo "CLI Command: $CMD"
            echo "CLI Output:"
            
            # Call CLI_OUTPUT.sh for each command and save the result in CLI_Output.txt
            ./CLI_OUTPUT_Script.sh "$CMD"
            echo
        done
        echo
    fi
else
    # Error message for unknown path
    echo
    echo "Error: Unknown GNMI path. Please provide a valid path."
    echo
    exit 1
fi
