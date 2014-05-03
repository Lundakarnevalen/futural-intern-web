#!/bin/bash

cd `dirname $0`

echo >> backup.log

date >> backup.log

./dumpdb.sh >> backup.log 2>&1

file="karnevalist.se-`date +%Y%m%d`.sql.xz"

./dropbox_uploader.sh upload "$file" "$file" >> backup.log 2>&1

rm $file
