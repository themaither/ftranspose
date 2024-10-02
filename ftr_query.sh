#!/usr/bin/sh
# Executes given FTranspose query and returns paths it yielded

# 0 is replaced with .

DBPATH=`ftr_ponder.sh`
SOURCEPATH=`cat $DBPATH/config/source`
if [ "$DBPATH" = "" ]
then
  echo Not inside a valid database
  exit 1
fi

function debug
{
  if [ "$DEBUG" = 1 ]
  then
    printf "\\e[2m`echo $@`\\e[0m\\n"
  fi
}

function trace
{
  if [ "$NOVERBOSE" = 1 ]
  then
    return
  fi
  echo $@
}

SELECTED=""

function fpush
{
  FILES=`realpath --relative-to $SOURCEPATH $@`
  debug Pushing $FILES
  if [ "$SELECTED" = "" ]
  then
    SELECTED="$FILES"
    return
  fi
  SELECTED="$SELECTED $FILES"
}

NOARG=0

function command_setup_0exit { NOARG=1; }
function command_0exit
{
  trace Exiting
  exit
}

function command_setup_0echo { NOARG=0; }
function command_0echo
{
  trace "$ARG"
}

function command_setup_0selected { NOARG=1; }
function command_0selected
{
  trace "$SELECTED"
}

function command_setup_select { NOARG=0; }
function command_select
{
  TARGET=$ARG 
  for NODE in $SOURCEPATH/$TARGET/*
  do
    if [ -d $NODE ]
    then
      ARG=$NODE
      command_select
      continue
    fi
    fpush $NODE
  done
}

while read TOKENS
do
  for TOKEN in $TOKENS
  do
    if [ "$COMMAND" = "" ]
    then
      COMMAND=`echo $TOKEN | sed s/\\\./0/`

      debug COMMAND=$COMMAND

      command_setup_$COMMAND #TODO: add check if setup was executed
      debug Set command!

      if [ $NOARG -eq 1 ]
      then
      command_$COMMAND
      debug Executed with no args
      COMMAND=""
      ARG=""
      fi

      continue
    fi
    
    ARG=$TOKEN
    command_$COMMAND
    debug Executed
    COMMAND=""
    ARG=""
  done
done
