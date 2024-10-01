#!/usr/bin/sh
# Executes given FTranspose query and returns pathes it yielded

# 0 is replased with .

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
  debug Pushing $@
  if [ "$SELECTED" = "" ]
  then
    SELECTED="$@"
    return
  fi
  SELECTED="$SELECTED $@"
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
  WD=$ARG
  for NODE in $WD/*
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