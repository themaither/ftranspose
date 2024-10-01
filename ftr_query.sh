#!/usr/bin/sh
# Executes given FTranspose query and returns pathes it yielded

while read TOKENS
do
  for TOKEN in $TOKENS
  do
    echo $TOKEN
  done
done