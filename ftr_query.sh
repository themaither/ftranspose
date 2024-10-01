#!/usr/bin/sh
# Executes given FTranspose query and returns pathes it yielded

while read TOKENS
do
  for TOKEN in $TOKENS
  do
    # echo $TOKEN

    # if [ $TOKEN = "select" ] 
    # do
    #   STATE=select
    # done

    if [ "$STATE" = select ]
    then
      echo "called $STATE with arg $TOKEN"
      STATE=""
      continue
    fi

    case $TOKEN in
      select )
        STATE=select
        ;;
      
      put )
        STATE=put
        ;;

      * )
        echo "Unrecognized command $TOKEN" > /proc/self/fd/2
    esac

  done
done