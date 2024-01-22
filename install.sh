#!/bin/bash

# Author christophecvr christophevanr@gmail.com
# 2024/01/14
if [ -z "$SUDO_USER" ];then
  echo "########################################################"
  echo "###### This instal script must be launched with sudo "
  echo "###### Retry with sudo <script>"
  echo "########################################################"
  exit
fi

# some default locations
PLIST_PATH="/Library/LaunchDaemons"
SCRIPTS_PATH="/Library/Scripts"
LOGS_PATH="/Library/Logs"

GIT_REPO_DIR="$PWD"
#echo $GIT_REPO_DIR
if [ "`echo "$GIT_REPO_DIR" | grep -o "macosx-script-boot-shutdown"`" != "macosx-script-boot-shutdown" ]; then
  # echo "$PWD This is not the git repo directory"
  GIT_REPO_LOC=`echo "/$0" | sed s/"\.\/"//g | sed s/"install.sh"//g | sed 's/\/*$//g'`
  GIT_REPO_DIR="$PWD$GIT_REPO_LOC"
  #echo "$GIT_REPO_DIR But this should be the git repo"
fi

# When using sudo the $HOME path remains that of user who is installing.
cd $HOME
if [ -f "$GIT_REPO_DIR/boot-shutdown-script.plist" ] && [ -f "$GIT_REPO_DIR/boot-shutdown.sh" ];then
  echo "git is ok install or uninstall can go"
else
  echo "Could not find the files to install or uninstall aborting process"
  exit
fi

echo ""
echo "########################################################################"
echo "### Git repository macosx-script-boot-shutdown is cloned and found"
echo "### I ask you some questions "
echo "### "
echo "### Git repo path: $GIT_REPO_DIR"
echo "### You're home path: $HOME"
echo "### The Installing user (You): $SUDO_USER"
echo "###"
echo "### Are the mentioned paths above right ? Yes/No  default Yes"
echo "########################################################################"
echo ""
read ANSWER
if [ "$ANSWER" == "No" ] || [ "$ANSWER" == "no" ];then
  echo ""
  echo "#############################################################################"
  echo "### You answered No are you shure the info is wrong ? You always can retry"
  echo "### If the info is not the right one automatic installation is not posible"
  echo "### Aborting installation"
  echo "#############################################################################"
  echo ""
  echo ""
  exit
fi
ANSWER=""
echo ""

TEST_PREVIOUS_INSTALL=`launchctl list BOOT.SHUTDOWN.SERVICE 2>/dev/null | grep -o BOOT.SHUTDOWN.SERVICE`
if [ "$TEST_PREVIOUS_INSTALL" == "BOOT.SHUTDOWN.SERVICE" ];then
  SERVICE="loaded"
  echo "Service Loaded"
fi
if [ -f "/Library/Logs/boot-shutdown-script-install.log" ];then
  echo "installog found"
  INSTALLED_PLIST_PATH=`grep "PLIST_PATH" /Library/Logs/boot-shutdown-script-install.log | sed s/"PLIST_PATH = "//g`
  echo $INSTALLED_PLIST_PATH
  INSTALLED_SCRIPTS_PATH=`grep "SCRIPTS_PATH" /Library/Logs/boot-shutdown-script-install.log | sed s/"SCRIPTS_PATH = "//g`
  echo $INSTALLED_SCRIPTS_PATH
  INSTALLED_LOGS_PATH=`grep "LOGS_PATH" /Library/Logs/boot-shutdown-script-install.log | sed s/"LOGS_PATH = "//g`
  echo $INSTALLED_LOGS_PATH
  if [ -f $INSTALLED_PLIST_PATH/boot-shutdown-script.plist ] && [ -f $INSTALLED_SCRIPTS_PATH/boot-shutdown.sh ];then
    SERVICE="$SERVICE""installed"
    echo "Service installed"
    echo "########################################################################################################"
    echo "### !!! If You wan't to reinstall this service after uninstalling do You wan't to keep You're path's !!!"
    echo "###"
    echo "### PLIST_PATH = $INSTALLED_PLIST_PATH"
    echo "### SCRIPTS_PATH = $INSTALLED_SCRIPTS_PATH"
    echo "### LOGS_PATH = $INSTALLED_LOGS_PATH"
    echo "###"
    echo "### Yes or No ? default is No. By default MacOs default paths will be used."
    echo "########################################################################################################"
    echo ""
    read KEEP_PATHS
    if [ "$KEEP_PATHS" == "Yes" ];then
      PLIST_PATH="$INSTALLED_PLIST_PATH"
      SCRIPTS_PATH="$INSTALLED_SCRIPTS_PATH"
      LOGS_PATH="$INSTALLED_LOGS_PATH"
      echo "paths changed to those from previous installation"
      KEEP_PATHS=""
    fi
  else
    echo ""
    echo "##############################################################################################"
    echo "### I did found a previous installog but no installation removing the installlog"
    echo "##############################################################################################"
    rm -f /Library/Logs/boot-shutdown-script-install.log
  fi
else
  #echo "No installog found try to find installation on default locations"
  if [ -f $PLIST_PATH/boot-shutdown-script.plist ] && [ -f $SCRIPTS_PATH/boot-shutdown.sh ];then
    echo "Did found installation on default location whitout installog"
    SERVICE="$SERVICE""installed"
    INSTALLED_PLIST_PATH=$PLIST_PATH
    INSTALLED_SCRIPTS_PATH=$SCRIPTS_PATH
    INSTALLED_LOGS_PATH=$LOGS_PATH
  else
    if [ -f $PLIST_PATH/boot-shutdown-script.plist ];then
      echo ""
      echo "################################################################################################################"
      echo "##### ****** !!! A $PLIST_PATH/boot-shutdown-script.plist is found !!!!!********"
      echo "##### This script does not find the boot-shutdown.sh file ."
      echo "##### Most probably You did previousely a manual installation"
      echo "##### Or used this script with non standard paths and removed the /Library/Logs/boot-shutdown-script-install.log"
      echo "##### If so first remove that installation manualy before using this script"
      echo "##### Uninstall and or Install process aborted"
      echo "################################################################################################################"
      echo "" 
      exit
    fi   
  fi
fi
if [ "$SERVICE" == "loadedinstalled" ] || [ "$SERVICE" == "installed" ];then
  echo ""
  echo "#########################################################################################################"
  echo "### A previous installation is found"
  echo "### By uninstalling you're changes into boot-shutdown.sh will be lost"
  echo "### Do you wan't to continu ? Yes or No default Yes"
  echo "#########################################################################################################"
  echo ""
  read ANSWER
  if [ "$ANSWER" == "No" ] || [ "$ANSWER" == "no" ];then
    echo ""
    echo "###########################################################################################"
    echo "###*** You selected to STOP the Install/Uninstalling process ***"
    echo "###########################################################################################"
    echo ""
    exit
  fi    
  if [ "$SERVICE" == "loadedinstalled" ];then
    launchctl unload -w $INSTALLED_PLIST_PATH/boot-shutdown-script.plist
    echo "unloading service"
  fi
  echo "removing previous installation"
  rm -f $INSTALLED_PLIST_PATH/boot-shutdown-script.plist
  rm -f $INSTALLED_SCRIPTS_PATH/boot-shutdown.sh
  if [ -f "$INSTALLED_LOGS_PATH/boot-shutdown.log" ];then
    rm -f $INSTALLED_LOGS_PATH/boot-shutdown.log
  fi
  if [ -f "$INSTALLED_LOGS_PATH/boot-shutdown.err" ];then
    rm -f $INSTALLED_LOGS_PATH/boot-shutdown.err
  fi
  echo ""
  echo "############################################################################################################"
  echo "### Previous installation has been unloaded and removed"
  echo "### Do you wan't to reinstall the service Yes or No !!!*** Default is Yes ***!!!"
  echo "############################################################################################################"
  echo ""
  read ANSWER
  if [ "$ANSWER" == "No" ] || [ "$ANSWER" == "no" ];then
    if [ -f "/Library/Logs/boot-shutdown-script-install.log" ];then
      rm -f "/Library/Logs/boot-shutdown-script-install.log"
    fi
    echo ""
    echo "#########################################################"
    echo "### You selected to NOT Reinstall The service"
    echo "### Previous installation is removed"
    echo "### Bye Bye."
    echo "#########################################################"
    exit
  fi
else
  if [ "$SERVICE" == "loaded" ];then
    echo ""
    echo "################################################################################################################"
    echo "##### ****** !!! A LOADED BOOT.SHUTDOWN.SERVICE has been found but no installation !!! ********"
    echo "##### This script does not find the installation self."
    echo "##### Most probably You did previousely a manual installation"
    echo "##### Or used this script with non standard paths and removed the /Library/Logs/boot-shutdown-script-install.log"
    echo "##### If so first remove that installation manualy before using this script"
    echo "##### Uninstall and or Install process aborted"
    echo "################################################################################################################"
    echo ""
    exit
  fi
fi

echo ""
echo "###################################################################################################"
echo "### This boot-shutdown-script is a system wide script and is a Launchdaemon."
echo "### It will perform the command or scripts You insert in the boot-shutdown.sh"
echo "### All actions are done with Superuser autorithy so be carrefull with what you do"
echo "### This script will install the files boot-shutdown.sh and boot-shutdown-script.plist on MacOs(x)"
echo "### Default locations for running superuser autorithy commands,programs and scripts."
echo "### For security reasons it is best to keep them since it is much less unsafe then using You're HOME DIR"
echo "### The owner ship of installed files will all be system (root) also the boot-shutdown.sh"
echo "### !!!! IF you set the boot-shutdown.sh in a directory or subdirectory of $HOME"
echo "### The file owner becomes You : $SUDO_USER !!!!"
echo "### To edit the boot-shutdown.sh you will need to use a script file editor who can run with sudo"
echo "### On board you all have the vi editor, can be used with sudo vi boot-shutdown.sh"
echo "### Or others script file editors such as gedit as a Linux user my favorite"
echo "### I well will give you the opportunity to change the locations during installation"
echo "### Only use full hard target paths if You change one of the locations"
echo "### ###############################################################################################"
echo ""
echo "########################################################################################################"
echo "### $PLIST_PATH = The default plistfile location Do You wan't to change it ? Yes/No default No"
echo "########################################################################################################"
read ANSWER
if [ "$ANSWER" == "Yes" ];then
  echo ""
  echo "########################################"
  echo "### Insert the wanted Location"
  echo "########################################"
  read ANSWER
  if [ -d "$ANSWER" ];then
    PLIST_PATH="$ANSWER"
  else
    echo ""
    echo "#######################################################################"
	echo "### Not a correct path keeping default $PLIST_PATH"
    echo "#######################################################################"
  fi
  ANSWER=""
fi
echo ""
echo "######################################################################################################"
echo "### $SCRIPTS_PATH = The default boot-shutdown.sh location Do You wan't to change it ? Yes/No default No"
echo "######################################################################################################"
read ANSWER
if [ "$ANSWER" == "Yes" ];then
  echo "#########################################################################################"
  echo "### Insert the wanted Location"
  echo "!!!! If You set it in director $HOME/ and above"
  echo "The user owner off file will become You:  $SUDO_USER !!!"
  echo "#########################################################################################"
  read ANSWER
  if [ -d "$ANSWER" ];then
    SCRIPTS_PATH="$ANSWER"
  else
    echo ""
    echo "############################################################################################"
    echo "### Not a correct path keeping default $SCIPTS_PATH"
    echo "############################################################################################"
  fi
  ANSWER=""
fi
echo ""
echo "###########################################################################################################"
echo "### $LOGS_PATH = The default log location. Do You wan't to change it ? Yes/No default No"
echo "###########################################################################################################"
read ANSWER
if [ "$ANSWER" == "Yes" ];then
  echo "#############################################"
  echo "### Insert the wanted location"
  echo "#############################################"
  read ANSWER
  if [ -d "$ANSWER" ];then
    LOGS_PATH="$ANSWER"
  else
    echo ""
    echo "################################################################"
    echo "### Not a correct path keeping default $LOGS_PATH"
    echo "################################################################"
  fi
  ANSWER=""
fi
echo ""
echo "############################################################################"
echo "### The current install paths are:"
echo "###"
echo "### $PLIST_PATH plist file"
echo "### $SCRIPTS_PATH script-files"
echo "### $LOGS_PATH Log files"
echo "###"
echo "### If You're happy with the paths we can proceed with the installation"
echo "### Do You wan't to proceed Yes/No default Yes"
echo "#############################################################################"

read ANSWER
if [ "$ANSWER" == "No" ];then
  echo ""
  echo "#######################################################"
  echo "#### You Aborted The Installation"
  echo "#######################################################"
  exit
fi

cp -f "$GIT_REPO_DIR/boot-shutdown-script.plist" "$PLIST_PATH"
cp -af "$GIT_REPO_DIR/boot-shutdown.sh" "$SCRIPTS_PATH"
if [ "`echo $SCRIPTS_PATH | grep -o "$SUDO_USER"`" == "$SUDO_USER" ];then
  chown $SUDO_USER "$SCRIPTS_PATH/boot-shutdown.sh"
else
  chown $USER "$SCRIPTS_PATH/boot-shutdown.sh"
fi

sed -i '' "s#SCRIPT_PATH#$SCRIPTS_PATH#g" "$PLIST_PATH/boot-shutdown-script.plist"
sed -i '' "s#LOG_PATH#$LOGS_PATH#g" "$PLIST_PATH/boot-shutdown-script.plist"

echo "Installation completed"
echo "Making a install Report"
INSTALL_LOG="/Library/Logs/boot-shutdown-script-install.log"
if [ ! -f "$INSTALL_LOG" ];then
touch $INSTALL_LOG
fi
echo ""
echo "######################################################" > $INSTALL_LOG
echo "Boot-shutdown-Install-report"  >> $INSTALL_LOG
echo "######################################################" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "echo `date "+%Y-%m-%d %H:%M:%S"` $SUDO_USER Installed macosx-script-boot-shutdown" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "Install Locations" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "GIT_REPO_DIR = $GIT_REPO_DIR" >> $INSTALL_LOG
echo "PLIST_PATH = $PLIST_PATH" >> $INSTALL_LOG
echo "SCRIPTS_PATH = $SCRIPTS_PATH" >> $INSTALL_LOG
echo "LOGS_PATH = $LOGS_PATH" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo "#################################################################" >> $INSTALL_LOG
echo "macosx-script-boot-shutdown INSTALLED" >> $INSTALL_LOG
echo "#################################################################" >> $INSTALL_LOG
echo "" >> $INSTALL_LOG
echo ""
echo "#################################################################"
echo "$INSTALL_LOG is completed"
echo "#################################################################"
if [ -f "$PLIST_PATH/boot-shutdown-script.plist" ];then
  launchctl load -w $PLIST_PATH/boot-shutdown-script.plist
  echo ""
  echo "###########################################################################################################"
  echo "### Boot shutdown Service is Installed and Loaded"
  echo "### You can add commands or scripts to $SCRIPTS_PATH/boot-shutdown.sh"
  echo "### Do not Forget to unload and reload the service after a change"
  echo "### To unload type: sudo launchctl unload -w $PLIST_PATH/boot-shutdown-script.plist "
  echo "### To load type: sudo launchctl load -w $PLIST_PATH/boot-shutdown-script.plist "
  echo "### Alternatively reboot two times to see the effects of the change."
  echo "###########################################################################################################"
else
  echo ""
  echo "###############################################################"
  echo "### Could not find the service due to a unknown error "
  echo "### !!! Installation failed !!!"
  echo "###############################################################"
fi











