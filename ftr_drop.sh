#!/usr/bin/sh
# Removes everything inside a database

DBPATH=`ftr_ponder.sh`
if [ "$DBPATH" = "" ]
then
  echo Not inside a valid database
  exit 1
fi

TARGETS=`echo $DBPATH/../*`

for TARGET in $TARGETS
do
  if [ `realpath $DBPATH` = `realpath $TARGET` ]
  then
    continue
  fi
  rm -r $TARGET
done