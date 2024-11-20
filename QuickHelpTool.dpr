program QuickHelpTool;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,Windows,System.Classes;

procedure ExecuteCommand(const Command: string);
var
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
  ExitCode: DWORD;
begin
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);

  if CreateProcess(nil, PChar('cmd.exe /c ' + Command), nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo) then
  begin
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end
  else
  begin
    Writeln('Command execution failed: ', SysErrorMessage(GetLastError));
  end;
end;


procedure ShowMenu;
begin
  Writeln('==============================');
  Writeln('         Command Menu         ');
  Writeln('==============================');
  Writeln('1. Get BIOS Serial Number');
  Writeln('2. Get IPv4 Address');
  Writeln('3. Check Windows License Expiration and Product Key');
  Writeln('4. Get System Information');
  Writeln('5. Show Windows Version');
  Writeln('6. Get OS Installation Date');
  Writeln('7. Get Logical Disk Information');
  Writeln('8. List Installed Updates');
  Writeln('9. Get CPU Information');
  Writeln('10. Get Memory (RAM) Information');
  Writeln('11. Force Group Policy Update');
  Writeln('12. List All User Accounts');
  Writeln('13. Get Logical Disk Information (duplicate)');
  Writeln('14. Check C: Drive for Errors');
  Writeln('15. Disable Windows Firewall');
  Writeln('16. Enable Windows Firewall');
  Writeln('17. Scan System Files for Integrity Violations');
  Writeln('18. Open Disk Cleanup Utility');
  Writeln('19. Upgrade All Installed Applications');
  Writeln('20. Reinstall All Appx Packages');
  Writeln('21. Flush DNS Resolver Cache');
  Writeln('22. Clean Temporary Files');
  Writeln('23. Optimize RAM');
  Writeln('24. Ping Test');
  Writeln('25. Traceroute');
  Writeln('26. DNS Query');
  Writeln('27. Display Active Network Connections');
  Writeln('28. Display ARP Table');
  Writeln('29. Display Routing Table');
  Writeln('30. Display NetBIOS Name Table');
  Writeln('31. Display IP Configuration');
  Writeln('32. Release IP Address');
  Writeln('33. Renew IP Address');
  Writeln('34. Show Wi-Fi Profile Details');
  Writeln('35. Exit');
  Writeln('==============================');
  Write('Please enter your choice (1-35): ');
end;

procedure HandleChoice(Choice: Integer);
var
  WifiName: string;
begin
  case Choice of
    1: ExecuteCommand('wmic bios get serialnumber');  // Get the BIOS serial number
    2: ExecuteCommand('ipconfig | findstr /i "IPv4"'); // Get the IPv4 address
    3: begin
         ExecuteCommand('slmgr /xpr'); // Check Windows license expiration
         ExecuteCommand('wmic path softwarelicensingservice get OA3xOriginalProductKey'); // Get the original product key
       end;
    4: ExecuteCommand('systeminfo'); // Get system information
    5: ExecuteCommand('winver'); // Show Windows version
    6: ExecuteCommand('wmic os get installdate'); // Get the installation date of the OS
    7: ExecuteCommand('wmic logicaldisk get caption, description, freespace, size'); // Get information about logical disks
    8: ExecuteCommand('wmic qfe list brief /format:table'); // List installed updates
    9: ExecuteCommand('wmic cpu get caption, deviceid, name, numberofcores, maxclockspeed'); // Get CPU information
    10: ExecuteCommand('wmic memorychip get capacity, speed, manufacturer'); // Get memory (RAM) information
    11: ExecuteCommand('gpupdate /force'); // Force Group Policy update
    12: ExecuteCommand('net user'); // List all user accounts
    13: ExecuteCommand('wmic logicaldisk get caption, description, freespace, size'); // Get information about logical disks (duplicate command)
    14: ExecuteCommand('chkdsk C: /f /r /x'); // Check the C: drive for errors
    15: ExecuteCommand('netsh advfirewall set allprofiles state off'); // Disable the Windows Firewall
    16: ExecuteCommand('netsh advfirewall set allprofiles state on'); // Enable the Windows Firewall
    17: ExecuteCommand('sfc /scannow'); // Scan system files for integrity violations
    18: ExecuteCommand('cleanmgr'); // Open Disk Cleanup utility
    19: ExecuteCommand('winget upgrade --all'); // Upgrade all installed applications using Windows Package Manager
    20: ExecuteCommand('powershell -Command "Get-AppxPackage | Foreach {Add-AppxPackage -Path $_.InstallLocation}"'); // Reinstall all Appx packages
    21: ExecuteCommand('ipconfig /flushdns'); // Flush the DNS resolver cache
    22: begin
         ExecuteCommand('del /q /f /s %TEMP%\*'); // Delete all files in the Temp directory
         ExecuteCommand('del /q /f /s %WINDIR%\Temp\*'); // Delete all files in the Windows Temp directory
         ExecuteCommand('cleanmgr /sagerun:1'); // Run Disk Cleanup with saved settings
       end;
    23: begin
         Writeln('Optimizing RAM...');
         ExecuteCommand('taskkill /f /im explorer.exe'); // Forcefully close Windows Explorer
         ExecuteCommand('start explorer.exe'); // Restart Windows Explorer
       end;
    24: begin
         Write('Enter the IP address for the ping test: ');
         Readln(WifiName);
         ExecuteCommand('ping ' + WifiName); // Ping a specified IP address
       end;
    25: begin
         Write('Enter the IP address for the traceroute: ');
         Readln(WifiName);
         ExecuteCommand('tracert ' + WifiName); // Perform a traceroute to a specified IP address
       end;
    26: begin
         Write('Enter the domain for the DNS query: ');
         Readln(WifiName);
         ExecuteCommand('nslookup ' + WifiName); // Perform a DNS lookup for a specified domain
       end;
    27: ExecuteCommand('netstat -an'); // Display active network connections
    28: ExecuteCommand('arp -a'); // Display the ARP table
    29: ExecuteCommand('route print'); // Display the routing table
    30: ExecuteCommand('nbtstat -n'); // Display NetBIOS name table
    31: ExecuteCommand('ipconfig'); // Display IP configuration
    32: ExecuteCommand('ipconfig /release'); // Release the IP address
    33: ExecuteCommand('ipconfig /renew'); // Renew the IP address
    34: begin
         Write('Enter the Wi-Fi network name: ');
         Readln(WifiName);
         ExecuteCommand('netsh wlan show profile name="' + WifiName + '" key=clear'); // Show Wi-Fi profile details including the password
       end;
    35: Writeln('Exiting...'); // Exit the program
  else
    Writeln('Invalid selection, please try again.'); // Handle invalid choices
  end;

  // Wait for user input before continuing
  if Choice <> 35 then
  begin
    Writeln('Press any key to continue...');
    Readln; // Wait for user to press a key
  end;
end;

var
  Choice: Integer;
begin
  repeat
    ShowMenu;
    Write('Please enter your choice (1-35): ');
    Readln(Choice);
    HandleChoice(Choice);
    Writeln;
  until Choice = 35;
end.
