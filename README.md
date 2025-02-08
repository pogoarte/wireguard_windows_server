This script must be run as administrator to work!  

It only works on 64 Bit Windows 10-11 Pro or later, it cannot be used on 64 Bit Windows 10-11 Home.

It install WireGuard and configure it as a server by enabling SERVICE, FORWARDING, NAT and create the client configuration.
All configuration files and keys will be generated on C:\Program Files\WirewGuard\Config and C:\Program Files\WirewGuard\Key.

It will ask for two things, the DNS or IP and the UDP PORT you want to use for the server, everything else it does automatically.
Remember to forward the UDP PORT on your router.
I also recommend rebooting after running the script to see if the WireGuard service loads regularly at startup, etc...

Before running the script, you must have Hyper-V or WSL installed in order to use the New-NetNat cmdlet to create the new NAT for WireGuard.
If you already have either one installed, you can run the script directly.
 
To install Hyper-V run from CMD as Administrator: DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
To install WSL run from CMD as Administrator:     DISM /Online /Enable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux  
You must reboot, after install, to activate Hyper-V or WSL.

If you cannot enable Hyper-V or WSL, it means that you have a version of Windows that is too old and does not support these features, there is no point in proceeding further.
