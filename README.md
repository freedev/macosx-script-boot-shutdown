MacOsx-script-boot-shutdown
===========================

This configuration is useful when you need to execute a shell script or command at Mac OS X boot or shutdown.

# Automatic Install and or Uninstall with install.sh

install.sh Is a user ineractif script to be runned as super user. How to use :
- open terminal
- type : cd ~
- type : git clone https://github.com/christophecvr/macosx-script-boot-shutdown
- type : sudo macosx-script-boot-shutdown/install.sh

The script will install the files:

- boot-shut-down-script.plist in path /Library/LaunchDaemons also adapt the target paths into the plist file.
- boot-shutdown.sh in path /library/Scripts this path can be adapted by user during install.
- log path location /Library/Logs this path can be adapted by user during install.

After the install is completed the script will be loaded

This installscript will also check on previous installation. 
Give the user the oportunity to stop or choose to remove the service from you're system.
Then the user will be asked to reinstall or not.
After the Install,Uninstall or Reinstall is done you will be asked to remove or not the
git repo from you're pc.

# Manual Install

There are two files:

- boot-shutdown-script.plist
- boot-shutdown.sh: bash shell script

# Install

You should customize the following placeholders inside the file boot-shutdown-script.plist:

- `BOOT.SHUTDOWN.SERVICE` : If you don't know, leave it as is
- `SCRIPT_PATH` : the path where the boot-shutdown.sh script is stored.
- `LOG_PATH` : the path where the logs are stored. If you don't care about logs, use: /tmp

Then copy the file `boot-shutdown-script.plist` into `/Library/LaunchDaemons/`

    sudo cp boot-shutdown-script.plist  /Library/LaunchDaemons/

When you want start the virtual machine type the following command:

    sudo launchctl load -w /Library/LaunchDaemons/boot-shutdown-script.plist

If you want stop the script (and the  you should type the following command:

    sudo launchctl unload -w /Library/LaunchDaemons/boot-shutdown-script.plist

The script will be started machine at every host boot.
Set into `boot-shutdown-script.plist` the field `RunAtLoad` to `false` if you don't want that the script starts automatically every time your mac os x boots.
When RunAtLoad is set to false, after the load you must start and stop the script using the following command:

    sudo launchctl start BOOT.SHUTDOWN.SERVICE
    sudo launchctl stop BOOT.SHUTDOWN.SERVICE

# After changing file boot-shutdown.sh

unload and reload the service in order to have changes directly applied
- open terminal
- type : sudo launchctl unload -w /Library/LaunchDaemons/boot-shutdown-script.plist
- type : sudo launchctl load -w /Library/LaunchDaemons/boot-shutdown-script.plist

Alternatively just restart(reboot) twice and You're changes should be in effect.

## Useful links

- [Daemons and Services Programming Guide][1]
- [What is Launchd][2]


  [1]: https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/Introduction.html
  [2]: http://www.launchd.info/ 

    
