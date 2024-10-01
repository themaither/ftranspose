#!/usr/bin/sh
# Executes given FTranspose query and returns pathes it yielded

# 0 is replased with .

function debug
{
  # printf \\e[35m"$@"\\e[0m\\n
  # printf `echo $@`
  printf "\\e[2m`echo $@`\\e[0m\\n"
}

function trace
{
  echo $@
}

NOARG=0

function command_setup_0exit
{
  NOARG=1
}

function command_0exit
{
  trace Exiting;
  exit
}

function command_setup_0echo
{
  NOARG=0
}

function command_0echo
{
  echo "$TOKEN"
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