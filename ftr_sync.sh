#!/usr/bin/sh
# Executes all queries inside sync

DBPATH=`ftr_ponder.sh`
if [ "$DBPATH" = "" ]
then
  echo Not inside a valid database
  exit 1
fi

ftr_drop.sh

function traverse 
{
  for NODE in $1
  do
    if [ -d $NODE ]
    then
      traverse "`echo $NODE/*`"
      continue
    fi
    ftr_query.sh $NODE
  done
}

traverse "`echo $DBPATH/sync/*`"