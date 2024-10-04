#!/usr/bin/sh
# Creates FTranspose database DB and getting files from SOURCE
if [ -z ${1+x} ] && [ -z ${2+x} ]
then
  echo "USAGE: $0 [SOURCE] [DB]"
  exit
fi

mkdir $2
mkdir $2/.trdb
mkdir $2/.trdb/config

# Really goofy way to write absolute path
ROOT=`pwd`
cd $1
echo `pwd` >> $ROOT/$2/.trdb/config/source
cd $ROOT

mkdir $2/.trdb/tags