#!/bin/bash

#
# Author: Vincenzo D'Amore v.damore@gmail.com
# 20/11/2014
#

function shutdown()
{
  echo `date` " " `whoami` " Received a signal to shutdown"

  exit 0
}

function startup()
{
        echo `date` " " `whoami` " Starting..."
}

trap shutdown SIGTERM
trap shutdown SIGKILL

