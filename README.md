macosx-vbox-headless
====================

A simple Mac OS X configuration and bash script to execute some commands during boot/shutdown

## Install

You should customize the following placeholders inside the file boot-shutdown-script.plist:

- `BOOT.SHUTDOWN.SERVICE` : If you don't know, leave it as is
- `SCRIPT_PATH` : the path where the boot-shutdown.sh script is stored.
- `LOG_PATH` : the path where the logs are stored. If you don't care about logs, use: /tmp

Then copy the file `boot-shutdown-script.plist` into `/Library/LaunchDaemons/`

    sudo cp boot-shutdown-script.plist  /Library/LaunchDaemons/

When you want start the virtual machine type the following command:

    sudo launchctl load -w /Library/LaunchDaemons/boot-shutdown-script.plist

If you want stop the VM (and the  you should type the following command:

    sudo launchctl unload -w /Library/LaunchDaemons/boot-shutdown-script.plist

The VM will be started machine everytime MAC OS X boots.
Set into `boot-shutdown-script.plist` the field `RunAtLoad` to `false` if you don't want that the VM starts automatically every time your mac os x boots.
When RunAtLoad is set to false, after the load you must start and stop the VM using the following command:

    sudo launchctl start BOOT.SHUTDOWN.SERVICE
    sudo launchctl stop BOOT.SHUTDOWN.SERVICE
