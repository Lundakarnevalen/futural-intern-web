#!/bin/bash
# Database dump by Johan Förberg

MYSQL="$(dirname $0)/mysql.sh"
LOGIN="$(dirname $0)/.mysql.cmd"

if ! [ -s $LOGIN ]; then
    $MYSQL <<<'' 2>/dev/null || exit 1
fi

mkfifo dumpdb.output
trap 'rm -f dumpdb.output' exit

mysqldump $(cat $LOGIN) | tee dumpdb.output | xz > karnevalist.se-`date +%Y%m%d`.sql.xz &

grep -- '-- Dump' < dumpdb.output

