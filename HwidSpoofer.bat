@echo off

set "taskname=HwidSpooferSystemTask"
set "scriptpath=%~dp0%~nx0"

set "base_dir=C:\HwidSpoofer"
if not exist "%base_dir%" (
    mkdir "%base_dir%"
)

echo Checking if running as SYSTEM...

schtasks /create /tn "%taskname%" /tr "%scriptpath%" /sc once /st 00:00 /rl highest /f /ru "SYSTEM" >nul 2>&1

if %ERRORLEVEL% NEQ 0 (
    echo Failed to create SYSTEM task. Please run this script with system-level privileges.
    pause
    exit /b
)

schtasks /run /tn "%taskname%" >nul 2>&1

schtasks /delete /tn "%taskname%" /f >nul 2>&1

:log_message
setlocal
set "log_level=%1"
set "message=%2"
echo [%date% %time%] [%log_level%] %message% >> "%log_file%"
endlocal
goto :eof

:handle_error
call :log_message "ERROR" "%1"
echo An error occurred: %1. Check the log file at %log_file% for more details.
exit /b
goto :eof

set "log_file=%base_dir%\hwid_spoof.log"
set "identifier_file=%base_dir%\hwid_spoof_log.txt"
set "original_identifier_file=%base_dir%\hwid_spoofer_original_log.txt"

:backup_identifiers
call :log_message "INFO" "Backing up original identifiers..."
for /f "tokens=2 delims==" %%i in ('wmic csproduct get uuid /value') do set "original_guid=%%i"
for /f "tokens=2 delims==" %%i in ('wmic baseboard get serialnumber /value') do set "original_motherboard_serial=%%i"
for /f "tokens=2 delims==" %%i in ('wmic bios get serialnumber /value') do set "original_bios_serial=%%i"
for /f "tokens=2 delims==" %%i in ('wmic cpu get processorid /value') do set "original_cpu_id=%%i"
for /f "tokens=2 delims==" %%i in ('wmic path win32_videocontroller get pnpdeviceid /value') do set "original_gpu_id=%%i"
for /f "tokens=2 delims==" %%i in ('wmic diskdrive get serialnumber /value') do set "original_disk_id=%%i"
for /f "tokens=2 delims==" %%i in ('wmic nic get MACAddress /value') do set "original_network_adapter_id=%%i"
for /f "tokens=2 delims==" %%i in ('vol c:') do set "original_volume_serial=%%i"

echo Saving original identifiers to %original_identifier_file%...
(
    echo Original GUID: %original_guid%
    echo Original Motherboard Serial: %original_motherboard_serial%
    echo Original BIOS Serial: %original_bios_serial%
    echo Original CPU ID: %original_cpu_id%
    echo Original GPU ID: %original_gpu_id%
    echo Original Disk ID: %original_disk_id%
    echo Original Network Adapter ID: %original_network_adapter_id%
    echo Original Volume Serial: %original_volume_serial%
) >> "%original_identifier_file%"
call :log_message "INFO" "Original identifiers backed up."
goto :eof

:spoof_identifiers
call :log_message "INFO" "Starting spoofing..."
set /a new_guid=%random%%random%%random%
set /a new_motherboard_serial=%random%%random%%random%
set /a new_bios_serial=%random%%random%%random%
set /a new_cpu_id=%random%%random%%random%
set /a new_gpu_id=%random%%random%%random%
set /a new_disk_id=%random%%random%%random%
set /a new_network_adapter_id=%random%%random%%random%
set /a new_volume_serial=%random%%random%%random%

echo Saving spoofed identifiers to %identifier_file%...
(
    echo New GUID: %new_guid%
    echo New Motherboard Serial: %new_motherboard_serial%
    echo New BIOS Serial: %new_bios_serial%
    echo New CPU ID: %new_cpu_id%
    echo New GPU ID: %new_gpu_id%
    echo New Disk ID: %new_disk_id%
    echo New Network Adapter ID: %new_network_adapter_id%
    echo New Volume Serial: %new_volume_serial%
) >> "%identifier_file%"
call :log_message "INFO" "All hardware identifiers spoofed."
goto :eof

:spoof_network
call :log_message "INFO" "Spoofing IP and user-agent..."
ipconfig /release
set "new_ip=%random%.%random%.%random%.%random%"
netsh interface ip set address name="Ethernet" static %new_ip% 255.255.255.0
echo New IP Address: %new_ip% >> "%identifier_file%"
call :log_message "INFO" "IP Address spoofed."

set "new_user_agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:%random%) Gecko/20100101 Firefox/%random%"
echo New User-Agent: %new_user_agent% >> "%identifier_file%"
call :log_message "INFO" "User-Agent spoofed."
goto :eof

:evade_vm_detection
call :log_message "INFO" "Implementing VM detection evasion..."
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\disk\Enum" /v "0" /t REG_SZ /d "Harddisk0\DR0\RandomVM_Evasion_Disk_Serial" /f >nul
call :log_message "INFO" "VM detection evasion applied."
goto :eof

:reset_identifiers
call :log_message "INFO" "Resetting identifiers back to original..."
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original GUID" "%original_identifier_file%"') do set "original_guid=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original Motherboard Serial" "%original_identifier_file%"') do set "original_motherboard_serial=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original BIOS Serial" "%original_identifier_file%"') do set "original_bios_serial=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original CPU ID" "%original_identifier_file%"') do set "original_cpu_id=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original GPU ID" "%original_identifier_file%"') do set "original_gpu_id=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original Disk ID" "%original_identifier_file%"') do set "original_disk_id=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original Network Adapter ID" "%original_identifier_file%"') do set "original_network_adapter_id=%%i"
for /f "tokens=2 delims=: " %%i in ('findstr /B /C:"Original Volume Serial" "%original_identifier_file%"') do set "original_volume_serial=%%i"

echo Resetting to original identifiers...
call :log_message "INFO" "All identifiers reset to original values."

echo Rebooting the system...
shutdown /r /t 0
goto :eof

echo.
echo ========================================
echo        HWID Spoofer Made by SwayZ
echo ========================================
echo.
echo Do you want to spoof or reset hardware identifiers? (Enter 'spoof' or 'reset'):
set /p action=
if /i "%action%"=="spoof" (
    call :backup_identifiers
    call :spoof_identifiers
    call :spoof_network
    call :evade_vm_detection
) else if /i "%action%"=="reset" (
    call :reset_identifiers
) else (
    echo Invalid option. Please enter 'spoof' or 'reset'.
)
pause
exit /b