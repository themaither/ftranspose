#!/usr/bin/sh
# Checks if working directory is attached to database and returns path to .trdb

ls .trdb 2> /dev/null > /dev/null #👁️‍🗨️
while [ $? != 0 ]
do
  if [ `pwd` = "/" ]
  then
    exit 1
  fi
  cd ..
  ls .trdb 2> /dev/null > /dev/null
done
cd .trdb
pwd