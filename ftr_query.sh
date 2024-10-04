#!/usr/bin/sh
# Executes given FTranspose query and returns paths it yielded

# 0 is replaced with .
DBPATH=`ftr_ponder.sh`
if [ "$DBPATH" = "" ]
then
  echo Not inside a valid database
  exit 1
fi
SOURCEPATH=`cat $DBPATH/config/source`
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
  FILES=`realpath --relative-to "$SOURCEPATH" "$@"`
  debug Pushing $FILES
  if [ "$SELECTED" = "" ]
  then
    SELECTED=$FILES
    return
  fi
  SELECTED=`echo $SELECTED $FILES | tr ' ' '\n' | sort | uniq | tr '\n' ' '`
  SELECTED=`printf "$SELECTED\n"`
  debug Selected = $SELECTED
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
  for NODE in `echo $SOURCEPATH/$TARGET/*`
  do
    debug node $NODE
    if [ -d $NODE ]
    then
      debug directory $NODE
      ARG=`realpath --relative-to $SOURCEPATH $NODE`
      command_select
      continue
    fi
    fpush $NODE
  done
}

function command_setup_contains { NOARG=0; }
function command_contains
{
  SELECTED=`echo $SELECTED | tr " " "\n" | grep $ARG | tr "\n" " " | sed s/$/"\n"/`
}

function command_setup_extension { NOARG=0; }
function command_extension
{
  SELECTED=`echo $SELECTED | tr " " "\n" | grep "\.$ARG"$ | tr "\n" " " | sed s/$/"\n"/`
}

function command_setup_ref { NOARG=0; }
function command_ref
{
  NEWPATH=$ARG

  for FILE in $SELECTED
  do
    mkdir -p $DBPATH/../$NEWPATH/$FILE
    rm -d $DBPATH/../$NEWPATH/$FILE # Really bad but should work
    ln -s $SOURCEPATH/$FILE $DBPATH/../$NEWPATH/$FILE
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

      command_setup_$COMMAND
      if [ $? -ne 0 ]
      then
        trace Unrecognized command $COMMAND
        COMMAND=""
        ARG=""
        continue
      fi
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
