@echo off 
cd /d %~dp0 
if not "%1" == "max" start /MAX cmd /c %0 max & exit/b 

cls 
NET SESSION >nul 2>&1 
IF %ERRORLEVEL% EQU 0 ( 
    ECHO Administrator PRIVILEGES Detected!  
) ELSE ( 
   echo. 
   echo  #### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #### 
   echo. 
   echo  This script must be run as administrator to work!   
   echo. 
   echo               Run it As Administrator! 
   echo. 
   echo  #### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #### 
   echo. 
   PAUSE 
   EXIT /B 1 
) 

cls 
   echo. 
   echo It only works on 64 Bit Windows 10-11 Pro or later, it cannot be used on 64 Bit Windows 10-11 Home. 
   echo.  
   echo It install WireGuard and configure it as a server by enabling SERVICE, FORWARDING, NAT and create the client configuration. 
   echo All configuration files and keys will be generated on C:\Programmi\WirewGuard\Config and C:\Programmi\WirewGuard\Key. 
   echo.  
   echo It will ask for two things, the DNS or IP and the UDP PORT you want to use for the server, everything else it does automatically. 
   echo Remember to forward the UDP PORT on your router. 
   echo I also recommend rebooting after running the script to see if the WireGuard service loads regularly at startup, etc... 
   echo. 
   echo Before running the script, you must have Hyper-V or WSL installed in order to use the New-NetNat cmdlet to create the new NAT for WireGuard. 
   echo If you already have either one installed, you can run the script directly. 
   echo.   
   echo To install Hyper-V run from CMD as Administrator: DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V 
   echo To install WSL run from CMD as Administrator:     DISM /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux   
   echo You must reboot, after install, to activate Hyper-V or WSL. 
   echo. 
   echo If you cannot enable Hyper-V or WSL, it means that you have a version of Windows that is too old and does not support these features, there is no point in proceeding further. 
   echo. 

:CECK 
powershell -Command "Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All | Where-Object { $_.State -eq 'Enabled' }" >nul 2>&1
if %errorlevel% neq 0 (
    exit /b 1
)
powershell -Command "Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux | Where-Object { $_.State -eq 'Enabled' }" >nul 2>&1
if %errorlevel% neq 0 (
    exit /b 1
)
SET /P RUN=Do you want run it? (n EXIT - y INSTALL): 
IF /I "%RUN%" EQU "n" EXIT 
IF /I "%RUN%" EQU "y" GOTO START 
GOTO CECK 

:START 
cls 
chdir %UserProfile%\Desktop
curl https://download.wireguard.com/windows-client/wireguard-amd64-0.5.3.msi -o wireguard-amd64-0.5.3.msi
curl http://pogoarte.altervista.org/files/apps/QREncode.exe -o QREncode.exe
MsiExec /i WireGuard-amd64-0.5.3.msi /qn 
taskkill /IM WireGuard /F 
set PATH=%PATH%;C:\%ProgramFiles%\WireGuard\ 
mkdir C:\%ProgramFiles%\WireGuard\Key 
mkdir C:\%ProgramFiles%\WireGuard\Config 
move QREncode.exe C:\%ProgramFiles%\WireGuard 
del WireGuard-amd64-0.5.3.msi

cls 
C:\%ProgramFiles%\WireGuard\wg genkey > C:\%ProgramFiles%\WireGuard\Key\wg_server.key 
C:\%ProgramFiles%\WireGuard\wg pubkey < C:\%ProgramFiles%\WireGuard\Key\wg_server.key > C:\%ProgramFiles%\WireGuard\Key\wg_server.pub 
C:\%ProgramFiles%\WireGuard\wg genkey > C:\%ProgramFiles%\WireGuard\Key\wg_client.key 
C:\%ProgramFiles%\WireGuard\wg pubkey < C:\%ProgramFiles%\WireGuard\Key\wg_client.key > C:\%ProgramFiles%\WireGuard\Key\wg_client.pub 
C:\%ProgramFiles%\WireGuard\wg genpsk > C:\%ProgramFiles%\WireGuard\Key\wg_client.psk 

cls 
set /P WG_SERVER_IP_DNS=WG SERVER IP or DNS (public not private): 
set /P WG_SERVER_UDP_PORT=WG SERVER UDP PORT (forward on router): 
set /P WG_SERVER.KEY=<C:\%ProgramFiles%\WireGuard\Key\wg_server.key 
set /P WG_SERVER.PUB=<C:\%ProgramFiles%\WireGuard\Key\wg_server.pub 
set /P WG_CLIENT.KEY=<C:\%ProgramFiles%\WireGuard\Key\wg_client.key 
set /P WG_CLIENT.PUB=<C:\%ProgramFiles%\WireGuard\Key\wg_client.pub 
set /P WG_CLIENT.PSK=<C:\%ProgramFiles%\WireGuard\Key\wg_client.psk 

cls 
type nul > C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo [Interface] > C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo PrivateKey = %WG_SERVER.KEY% >> C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo ListenPort = %WG_SERVER_UDP_PORT% >> C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo MTU = 1420 >>  C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo Address = 10.0.69.1/24 >>  C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo [Peer] >>  C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo PublicKey = %WG_CLIENT.PUB% >>  C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo PresharedKey = %WG_CLIENT.PSK% >>  C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 
echo AllowedIPs = 10.0.69.2/32 >>  C:\%ProgramFiles%\WireGuard\Config\wg_server.conf 

cls 
type nul > C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo [Interface] > C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo PrivateKey = %WG_CLIENT.KEY% >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo Address = 10.0.69.2/24 >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo [Peer] >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo PublicKey = %WG_SERVER.PUB% >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo PresharedKey = %WG_CLIENT.PSK% >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo Endpoint = %WG_SERVER_IP_DNS%:%WG_SERVER_UDP_PORT% >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo AllowedIPs = 0.0.0.0/1,128.0.0.0/1 >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 
echo PersistentKeepalive = 25 >> C:\%ProgramFiles%\WireGuard\Config\wg_client.conf 

cls 
C:\%ProgramFiles%\WireGuard\WireGuard /installtunnelservice "C:\%ProgramFiles%\WireGuard\Config\wg_server.conf" 

cls 
powershell -command "Start-Sleep -s 3" 
powershell -command "Get-NetIPInterface 'wg_server' | Set-NetIPInterface -Forwarding Enabled" 
powershell -command "New-NetNat -Name wg_server_nat -InternalIPInterfaceAddressPrefix '10.0.69.0/24'" 
powershell -command "Set-NetConnectionProfile -InterfaceAlias 'wg_server' -NetworkCategory 'Private'" 

cls 
C:\%ProgramFiles%\WireGuard\QREncode -r C:\%ProgramFiles%\WireGuard\Config\wg_client.conf -o C:\%ProgramFiles%\WireGuard\Config\wg_client.png -s 6 
rundll32 "C:\%ProgramFiles%\Windows Photo Viewer\photoviewer.dll",ImageView_Fullscreen C:\%ProgramFiles%\WireGuard\Config\wg_client.png

EXIT 0 
