# HWID Spoofer

This script is designed to spoof hardware identifiers (HWIDs) on a Windows system. It can also reset these identifiers to their original values. The script operates by creating a scheduled task that runs with 'SYSTEM' privileges, performs the spoofing operations, and handles logging and error management.

## Features

- **Backup Original Identifiers:** Backs up current hardware identifiers to a log file.
- **Spoof Identifiers:** Generates and saves new, random hardware identifiers.
- **Spoof Network Details:** Changes IP address and user-agent.
- **VM Detection Evasion:** Modifies registry settings to evade virtual machine (VM) detection.
- **Reset Identifiers:** Restores original hardware identifiers.
- **Logging:** Detailed logging of operations and errors.

## Prerequisites

- It's a Living Off The Land Binary (LOLBin) Proof of Concept (POC), nothing is needed for it to run.
## Installation

1. **Download the Script:**
   - Save the script as `HwidSpoofer.bat` or any name you prefer.

2. **Prepare Directory:**
   - The script will create a directory `C:\HwidSpoofer` if it does not already exist.

## Usage

### Running the Script

1. Open Command Prompt as Administrator.
2. Navigate to the directory where the script is located.
3. Execute the script by typing `HwidSpoofer.bat`.

### Choosing an Action

When prompted, you can choose between the following actions:

- **`spoof`:** Back up original identifiers, spoof new identifiers, modify network details, and apply VM detection evasion.
- **`reset`:** Restore original identifiers to their previous values.

### Example Commands

To spoof identifiers:

```
HwidSpoofer.bat
```

When prompted, type `spoof` and press Enter.

To reset identifiers:

```
HwidSpoofer.bat
```

When prompted, type `reset` and press Enter.

## Script Workflow

1. **Check for SYSTEM Privileges:**
   - The script creates a scheduled task with SYSTEM privileges to ensure it can perform all operations.

2. **Backup Identifiers:**
   - The script backs up current identifiers (e.g., GUID, motherboard serial, BIOS serial, etc.) to a log file.

3. **Spoof Identifiers:**
   - Randomly generated values are used to spoof hardware identifiers.

4. **Spoof Network Details:**
   - Changes the IP address and user-agent.

5. **Apply VM Detection Evasion:**
   - Modifies registry settings to evade VM detection.

6. **Reset Identifiers:**
   - Restores original identifiers from the backup log.

7. **Logging and Error Handling:**
   - All actions and errors are logged to `C:\HwidSpoofer\hwid_spoof.log`.

## Error Handling

If an error occurs:

- The script logs the error message and provides instructions to check the log file for details.

## File Descriptions

- `HwidSpoofer.bat`: Main script file.
- `hwid_spoof.log`: Log file for recording operations and errors.
- `hwid_spoofer_original_log.txt`: File storing backed-up original identifiers.

## Notes

- Running the script with SYSTEM privileges is crucial for successful operation.
- The script makes modifications to network settings and registry keys, which can affect system behavior.

## Disclaimer

This script is intended for educational and informational purposes only. Use responsibly and understand the implications of modifying hardware identifiers and system settings.

## License

This script is provided as-is with no warranties. Use at your own risk.
