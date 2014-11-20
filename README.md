macosx-vbox-headless
====================

A simple Mac OS X configuration and bash script to execute some commands during boot/shutdown

## Install

You should customize the following placeholders inside the file boot-shutdown-script.list:

BOOT.SHUTDOWN.SERVICE

- `BOOT.SHUTDOWN.SERVICE` : This required key uniquely identifies the job. If you don't have multiple vbox you can leave it as is.
- `PATH_TO` : the path where the vbox.sh script is stored.
- `WORKING_DIRECTORY_PATH` : the path where the logs are stored. If you don't care about it, use: /tmp
- `USERNAME` : This is your username.

Then copy the file `boot-shutdown-script.list` into `/Library/LaunchDaemons/`

    sudo cp boot-shutdown-script.list  /Library/LaunchDaemons/

When you want start the virtual machine type the following command:

    sudo launchctl load -w /Library/LaunchDaemons/boot-shutdown-script.list

If you want stop the VM (and the  you should type the following command:

    sudo launchctl unload -w /Library/LaunchDaemons/boot-shutdown-script.list

The VM will be started machine everytime MAC OS X boots.
Set into `boot-shutdown-script.list` the field `RunAtLoad` to `false` if you don't want that the VM starts automatically every time your mac os x boots.
When RunAtLoad is set to false, after the load you must start and stop the VM using the following command:

    sudo launchctl start BOOT.SHUTDOWN.SERVICE
    sudo launchctl stop BOOT.SHUTDOWN.SERVICE
