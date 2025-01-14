#!/bin/bash

# Input: GNMI Path
GNMI_PATH=$1

# Check if a path is provided
if [ -z "$GNMI_PATH" ]; then
    echo "Usage: $0 <GNMI_PATH>"
    exit 1
fi

# Output file
OUTPUT_FILE="GNMI_Output.json"
# Clear the output file to start fresh
> CLI_Output.txt

# Define a dictionary (associative array) for GNMI paths and outputs
declare -A GNMI_DATA

# Populate the dictionary with GNMI paths and their corresponding JSON outputs
GNMI_DATA["/interfaces/interface[name=eth0]/state/counters"]='{
    "in_octets": 1500000,
    "out_octets": 1400000,
    "in_errors": 10,
    "out_errors": 2
}'
GNMI_DATA["/system/memory/state"]='{
    "total_memory": 4096000,
    "available_memory": 1024000
}'
GNMI_DATA["/interfaces/interface[name=eth1]/state/counters"]='{
    "in_octets": 200000,
    "out_octets": 100000,
    "in_errors": 5
}'
GNMI_DATA["/system/cpu/state/usage"]='{
    "cpu_usage": 65,
    "idle_percentage": 35
}'
GNMI_DATA["/routing/protocols/protocol[ospf]/ospf/state"]='{
    "ospf_area": "0.0.0.0",
    "ospf_state": "up"
}'
GNMI_DATA["/interfaces/interface[name=eth0]/state"]='{
    "admin_status": "up",
    "oper_status": "up",
    "mac_address": "00:1C:42:2B:60:5A",
    "mtu": 1500,
    "speed": 1000
}'
GNMI_DATA["/bgp/neighbors/neighbor[neighbor_address=10.0.0.1]/state"]='{
    "peer_as": 65001,
    "connection_state": "Established",
    "received_prefix_count": 120,
    "sent_prefix_count": 95
}'
GNMI_DATA["/system/cpu/state"]='{
    "cpu_usage": 75,
    "user_usage": 45,
    "system_usage": 20,
    "idle_percentage": 25
}'
GNMI_DATA["/ospf/areas/area[id=0.0.0.0]/state"]='{
    "area_id": "0.0.0.0",
    "active_interfaces": 4,
    "lsdb_entries": 200,
    "adjacencies": [
        {"neighbor_id": "1.1.1.1", "state": "full"},
        {"neighbor_id": "2.2.2.2", "state": "full"}
    ]
}'
GNMI_DATA["/system/disk/state"]='{
    "total_space": 1024000,
    "used_space": 500000,
    "available_space": 524000,
    "disk_health": "good"
}'

# Check if the provided path exists in the dictionary
if [[ -v GNMI_DATA["$GNMI_PATH"] ]]; then
    # Write the corresponding JSON output to the file
    echo
    echo "GNMI data for path '$GNMI_PATH' is:"
    echo "${GNMI_DATA[$GNMI_PATH]}"
    echo "${GNMI_DATA[$GNMI_PATH]}" > $OUTPUT_FILE
else
    # Error message for unknown path
    echo "Error: Unknown GNMI path. Please provide a valid path."
    exit 1
fi
