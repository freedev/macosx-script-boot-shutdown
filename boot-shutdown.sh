#!/bin/bash

#
# Author: Vincenzo D'Amore v.damore@gmail.com
# 20/11/2014
#

function shutdown()
{
  echo `date` " " `whoami` " Received a signal to shutdown"

  # INSERT HERE THE COMMAND YOU WANT EXECUTE AT SHUTDOWN

  exit 0
}

function startup()
{
  echo `date` " " `whoami` " Starting..."

  # INSERT HERE THE COMMAND YOU WANT EXECUTE AT STARTUP

  tail -f /dev/null &
  wait $!
}

trap shutdown SIGTERM
trap shutdown SIGKILL

startup;

