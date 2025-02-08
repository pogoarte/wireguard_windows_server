This script must be run as administrator to work!  

It only works on 64 Bit Windows 10-11 Pro or later, it cannot be used on 64 Bit Windows 10-11 Home.

It install WireGuard and configure it as a server by enabling SERVICE, FORWARDING, NAT and create the client configuration. <br />
All configuration files and keys will be generated on C:\Program Files\WirewGuard\Config and C:\Program Files\WirewGuard\Key. <br />

It will ask for two things, the DNS or IP and the UDP PORT you want to use for the server, everything else it does automatically. <br />
Remember to forward the UDP PORT on your router. <br />
I also recommend rebooting after running the script to see if the WireGuard service loads regularly at startup, etc... <br />

Before running the script, you must have Hyper-V or WSL installed in order to use the New-NetNat cmdlet to create the new NAT for WireGuard. <br />
If you already have either one installed, you can run the script directly. <br />
 
To install Hyper-V run from CMD as Administrator: DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V <br />
To install WSL run from CMD as Administrator:     DISM /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux <br />
You must reboot, after install, to activate Hyper-V or WSL. <br />

If you cannot enable Hyper-V or WSL, it means that you have a version of Windows that is too old and does not support these features, there is no point in proceeding further. <br />
