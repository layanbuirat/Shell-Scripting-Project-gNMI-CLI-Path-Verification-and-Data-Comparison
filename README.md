# gNMI CLI Path Verification and Data Comparison Project

## 📋 Overview
This project automates the verification and comparison of network device configurations and state data between CLI (Command Line Interface) and gNMI (gRPC Network Management Interface) data collection methods. It's designed for network engineers and DevOps teams working with network automation and validation.

## 🚀 Key Features
- **Dual Data Collection**: Automatically gathers data from network devices using both CLI commands and gNMI protocols
- **Structured Output**: Organizes collected data into separate directories for CLI and gNMI outputs
- **Automated Comparison**: Compares CLI and gNMI data to identify discrepancies and ensure consistency
- **Flexible Path Specification**: Supports various gNMI paths for different network device components
- **Error Handling**: Includes validation and timeout mechanisms for reliable execution

## 🏗️ Project Structure
```
├── Main_Script.sh                    # Main orchestration script
├── GNMI_Script.sh                    # gNMI data collection script
├── CLI_Command_Script.sh             # CLI command generation script
├── CLI_OUTPUT_Script.sh              # CLI output collection script
├── Compare_Script.sh                 # Data comparison script
├── outputs/                          # Collected data directory
│   ├── cli/                          # CLI command outputs
│   └── gnmi/                         # gNMI protocol outputs
└── GNMI_Output.json                  # Sample gNMI output format
```

## 📦 Prerequisites
- **Operating System**: Linux (Ubuntu/Debian preferred)
- **Network Access**: Connectivity to target network devices
- **Required Tools**:
  - `gnmic`: gNMI client tool (part of the gNMIc suite)
  - `telnet` or `ssh`: For CLI access to devices
  - `nmap`: For network discovery and port scanning
  - `sed`: For text processing and data transformation
- **Credentials**: Valid username/password for network devices
- **gNMI Access**: Devices must have gNMI service enabled (typically port 57400)

## 🔧 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/layanbuirat/Shell-Scripting-Project-gNMI-CLI-Path-Verification-and-Data-Comparison.git
cd Shell-Scripting-Project-gNMI-CLI-Path-Verification-and-Data-Comparison
```

### 2. Install Required Packages
```bash
sudo apt update
sudo apt install -y nmap telnet ssh sed
```

### 3. Install gNMI Client (gnmic)
Follow the installation instructions from [gNMIc GitHub repository](https://github.com/karimra/gnmic)

### 4. Set Execution Permissions
```bash
chmod +x *.sh
```

## 🎯 Usage

### Basic Usage
Run the main script with a specific gNMI path:
```bash
./Main_Script.sh "/interfaces/interface[name=eth0]/state/counters"
```

### Supported gNMI Path Examples
- `/system/memory/state`
- `/system/cpu/state`
- `/interfaces/interface[name=eth0]/state/counters`
- `/bgp/neighbors/neighbor[neighbor_address=10.0.0.1]/state`
- `/ospf/areas/area[id=0.0.0.0]/state`
- `/system/disk/state`
- `/interfaces/interface[name=eth0]/state/admin-status`

### Script Execution Flow
1. **Main Script** (`Main_Script.sh`): Orchestrates the entire process
2. **gNMI Collection** (`GNMI_Script.sh`): Collects data via gNMI protocol
3. **CLI Command Generation** (`CLI_Command_Script.sh`): Maps gNMI paths to CLI commands
4. **CLI Output Collection** (`CLI_OUTPUT_Script.sh`): Executes CLI commands and captures output
5. **Data Comparison** (`Compare_Script.sh`): Compares gNMI and CLI data for consistency

## 🔍 Configuration

### Device Connection Settings
Edit the scripts to configure:
- Device IP addresses
- Username and password credentials
- Connection ports (default: 57400 for gNMI)
- Timeout settings

### Customizing Data Collection
Modify the mapping in `CLI_Command_Script.sh` to add support for additional gNMI paths and their corresponding CLI commands.

## 📊 Output Files

### CLI Outputs
Located in `outputs/cli/` directory with naming convention:
```
<device_name>_<path_sanitized>_cli.txt
```

### gNMI Outputs
Located in `outputs/gnmi/` directory with naming convention:
```
<device_name>_<path_sanitized>_gnmi.json
```

### Comparison Results
Generated comparison files highlight differences between CLI and gNMI data outputs.

## 🛠️ Troubleshooting

### Common Issues

1. **Connection Timeout**
   - Verify device IP and port accessibility
   - Check firewall rules
   - Confirm gNMI service is running on the device

2. **Authentication Failure**
   - Verify username/password credentials
   - Check for special characters in passwords (use escape sequences if needed)

3. **gNMI Path Errors**
   - Ensure the gNMI path is valid for the target device
   - Check device documentation for supported paths

4. **Missing Dependencies**
   - Ensure all required packages are installed
   - Verify `gnmic` is in PATH

### Debug Mode
Add `set -x` at the beginning of scripts to enable debug output:
```bash
#!/bin/bash
set -x  # Enable debugging
# ... rest of script
```

## 📈 Example Execution

```bash
# Example 1: Check interface counters
./Main_Script.sh "/interfaces/interface[name=eth0]/state/counters"

# Example 2: Check system memory
./Main_Script.sh "/system/memory/state"

# Example 3: Check BGP neighbor state
./Main_Script.sh "/bgp/neighbors/neighbor[neighbor_address=10.0.0.1]/state"
```

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author
**Layan Buriat**
- GitHub: [@layanbuirat](https://github.com/layanbuirat)
**Raghad Murad**
   - GitHub: [@RaghadMurad](https://github.com/raghad-murad)

## 🙏 Acknowledgments
- The gNMIc project team for the excellent gNMI client tool
- OpenConfig working group for the gNMI specification
- All contributors and testers of this project

---

**Note**: Always test scripts in a non-production environment first. Ensure you have proper authorization before accessing network devices.
