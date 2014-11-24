macosx-script-boot-shutdown
===========================

This configuration is useful When you need to execute a shell script at Mac OS X boot or shutdown.

There are two files:

- boot-shutdown-script.plist: [Mac OS X daemon/agent configuration file (plist)][1]
- boot-shutdown.sh: bash shell script


## Install

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

  [1]: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man5/launchd.plist.5.html
    