#!/bin/bash

# Input: CLI Command
CLI_COMMAND=$1

# Check if a command is provided
if [ -z "$CLI_COMMAND" ]; then
    echo "Usage: $0 <CLI_COMMAND>"
    exit 1
fi

# Output file
OUTPUT_FILE="CLI_Output.txt"

# Define a dictionary to map CLI commands to their outputs
declare -A CLI_Output

# Add CLI commands and their outputs to the dictionary
CLI_Output["show interfaces eth0 counters"]="in_octets: 1500000;out_octets: 1400000;in_errors: 10;out_errors: 2"
CLI_Output["show memory"]="total_memory: 4096000;available_memory: 1000000"
CLI_Output["show interfaces eth1 counters"]="in_octets: 200000;out_octets: 100000"
CLI_Output["show cpu"]="cpu_usage: 65"
CLI_Output["show ospf status"]="ospf_area: \"0.0.0.0\";ospf_state: \"down\""
CLI_Output["show interfaces eth0 status"]="admin_status: up;oper_status: up"
CLI_Output["show interfaces eth0 mac-address"]="mac_address: 00:1C:42:2B:60:5A"
CLI_Output["show interfaces eth0 mtu"]="mtu: 1500"
CLI_Output["show interfaces eth0 speed"]="speed: 1000"
CLI_Output["show bgp neighbors 10.0.0.1"]="peer_as: 65001;connection_state: Established"
CLI_Output["show bgp neighbors 10.0.0.1 received-routes"]="received_prefix_count: 120"
CLI_Output["show bgp neighbors 10.0.0.1 advertised-routes"]="sent_prefix_count: 95"
CLI_Output["show cpu usage"]="cpu_usage: 75"
CLI_Output["show cpu user"]="user_usage: 45"
CLI_Output["show cpu system"]="system_usage: 20"
CLI_Output["show cpu idle"]="idle_percentage: 25"
CLI_Output["show ospf area 0.0.0.0"]="area_id: 0.0.0.0;active_interfaces: 4;lsdb_entries: 200"
CLI_Output["show ospf neighbors"]="neighbor_id: 1.1.1.1, state: full;neighbor_id: 2.2.2.2, state: full"
CLI_Output["show disk space"]="total_space: 1024000;used_space: 500000;available_space: 524000"
CLI_Output["show disk health"]="disk_health: good"

# Check if the provided CLI command exists in the dictionary
if [[ -v CLI_Output["$CLI_COMMAND"] ]]; then
    # Split the commands using semicolon and execute each command
    IFS=';' read -ra OUTPUT <<< "${CLI_Output["$CLI_COMMAND"]}"
        for OUT in "${OUTPUT[@]}"; do
            # Print the output of the CLI command
            echo $OUT
            echo -e $OUT >> $OUTPUT_FILE
        done
else
    # Error message for unknown CLI command
    echo
    echo "Error: Unknown CLI command. Please provide a valid command."
    echo
    exit 1
fi
